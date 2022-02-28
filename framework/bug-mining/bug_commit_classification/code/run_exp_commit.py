import os
os.environ["CUDA_VISIBLE_DEVICES"] = '1'

from transformers import AutoTokenizer, AutoModelForSequenceClassification
from transformers import AdamW, get_scheduler
import transformers
import torch
import numpy as np
from dataloader import load_cross_validation_split
from preprocesser import process_commit_info
from tqdm.auto import tqdm
import json
import random

# Environ Hyperparams
seed = 1234
transformers.set_seed(seed)
device = torch.device("cuda") if torch.cuda.is_available() else torch.device("cpu")

# Data Hyperparams
use_filtered = False
n_fold = 10
positive_thresholds = [0.5, 0.6, 0.7, 0.8, 0.9, 0.92, 0.94, 0.96, 0.98, 0.99]

# Model Hyperparams
model_name = "roberta-base" #"bert-base-uncased"
n_class = 2
n_epoch = 10
batch_size = 32
lr = 1e-5
lr_sche = "linear"
warmup_steps = 1000 // batch_size

# Load k-fold Data
labels, commits, _ = load_cross_validation_split(use_filtered)

# Cross Validation
acc_list, prec_list, recall_list = [], [], []
th_accs_list, th_precs_list, th_recalls_list = [], [], []
prob_dict = {}
for fold_idx in range(n_fold):
    print("[Fold {}]".format(fold_idx+1), end=" ")
    prob_dict["fold_{}".format(fold_idx+1)] = {}

    # Init Tokenizer & Model
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForSequenceClassification.from_pretrained(model_name, num_labels=n_class)
    num_params = 0
    for param in model.parameters():
        num_params += param.numel()
    print("model size", num_params, end=" ")
    model.to(device)

    # Get Train/Eval Split
    label_eval, commit_eval = labels[fold_idx], commits[fold_idx]
    label_train, commit_train = [], []
    for idx in range(n_fold):
        if idx != fold_idx:
            label_train += labels[idx]
            commit_train += commits[idx]
    assert len(label_eval)==len(commit_eval)
    assert len(label_train)==len(commit_train)
    print("train {} valid {}".format(len(label_train), len(label_eval)))

    # Preprocess Data
    if not use_filtered: # for the new version, preprocess is after cross-valid spliting
        commit_eval = [process_commit_info(cmt) for cmt in commit_eval]
        commit_train = [process_commit_info(cmt) for cmt in commit_train]

    # Init Optimizer
    optimizer = AdamW(model.parameters(), lr=lr)
    num_training_steps = n_epoch*len(label_train)
    lr_scheduler = get_scheduler(
        lr_sche, 
        optimizer=optimizer, 
        num_warmup_steps=warmup_steps, 
        num_training_steps=num_training_steps)

    # Evaluate Helper
    def evaluate():
        # init statistics
        total_correct, total_n, true_positive, false_positive, false_negative = 0, 0, 0, 0, 0
        total_correct_list = [0 for i in range(len(positive_thresholds))]
        total_n_list = [0 for i in range(len(positive_thresholds))]
        true_positive_list = [0 for i in range(len(positive_thresholds))]
        false_positive_list = [0 for i in range(len(positive_thresholds))]
        false_negative_list = [0 for i in range(len(positive_thresholds))]
        all_positive_probs = []
        # from train() -> eval()
        model.eval()
        n_eval = len(label_eval)
        for batch_idx in range((n_eval-1)//batch_size + 1):
            # prepare batch
            eval_sents = commit_eval[batch_idx*batch_size:(batch_idx+1)*batch_size]
            eval_input = tokenizer(eval_sents, padding="max_length", truncation=True, return_tensors="pt") # input_ids & attention_mask
            eval_labels = np.asarray(label_eval[batch_idx*batch_size:(batch_idx+1)*batch_size])
            eval_input["labels"] = torch.from_numpy(eval_labels)
            eval_batch = {k: v.to(device) for k, v in eval_input.items()}
            # forward
            with torch.no_grad():
                outputs = model(**eval_batch)
            logits = outputs.logits
            predictions = torch.argmax(logits, dim=-1).cpu().numpy()
            # statistics
            total_correct += sum(predictions==eval_labels)
            total_n += predictions.shape[0]
            true_positive += sum(np.logical_and(eval_labels==1, predictions==1))
            false_positive += sum(np.logical_and(eval_labels==0, predictions==1))
            false_negative += sum(np.logical_and(eval_labels==1, predictions==0))
            # statistics based on thresholds
            probs = torch.nn.functional.softmax(logits, dim=-1).cpu().numpy()
            positive_probs = probs[:, 1]
            all_positive_probs += positive_probs.tolist()
            for i, positive_threshold in enumerate(positive_thresholds):
                th_predictions = (positive_probs > positive_threshold).astype(np.int32)
                total_correct_list[i] += sum(th_predictions==eval_labels)
                total_n_list[i] += th_predictions.shape[0]
                true_positive_list[i] += sum(np.logical_and(eval_labels==1, th_predictions==1))
                false_positive_list[i] += sum(np.logical_and(eval_labels==0, th_predictions==1))
                false_negative_list[i] += sum(np.logical_and(eval_labels==1, th_predictions==0))
        # collect statistics
        assert total_n==n_eval, "{} vs {}".format(total_n, n_eval)
        acc = total_correct/total_n
        prec = true_positive/(true_positive+false_positive)
        recall = true_positive/(true_positive+false_negative)
        threshold_accs = [total_correct_list[i]/total_n_list[i] for i in range(len(positive_thresholds))]
        threshold_precs = [true_positive_list[i]/(true_positive_list[i]+false_positive_list[i]) for i in range(len(positive_thresholds))]
        threshold_recalls = [true_positive_list[i]/(true_positive_list[i]+false_negative_list[i]) for i in range(len(positive_thresholds))]
        return acc, prec, recall, threshold_accs, threshold_precs, threshold_recalls, all_positive_probs

    # Each Epoch
    #progress_bar = tqdm(range(num_training_steps))
    n_train = len(label_train)
    best_acc, best_prec, best_recall = 0, 0, 0
    best_th_accs = [0 for i in range(len(positive_thresholds))]
    best_th_precs = [0 for i in range(len(positive_thresholds))]
    best_th_recalls = [0 for i in range(len(positive_thresholds))]
    for epoch in range(n_epoch):
        # Train
        model.train()
        avg_loss, avg_cnt = 0, 0
        # shuffle training data in each epoch
        shuffle_ids = random.sample(range(n_train), n_train)
        label_tr = [label_train[sid] for sid in shuffle_ids]
        sent_tr = [commit_train[sid] for sid in shuffle_ids]
        for batch_idx in range((n_train-1)//batch_size + 1):
            # prepare batch
            tr_sents = sent_tr[batch_idx*batch_size:(batch_idx+1)*batch_size]
            tr_input = tokenizer(tr_sents, padding="max_length", truncation=True, return_tensors="pt") # input_ids & attention_mask
            tr_labels = label_tr[batch_idx*batch_size:(batch_idx+1)*batch_size]
            tr_input["labels"] = torch.from_numpy(np.asarray(tr_labels))
            tr_batch = {k: v.to(device) for k, v in tr_input.items()}
            # forward
            outputs = model(**tr_batch)
            loss = outputs.loss
            avg_loss += loss.item()
            avg_cnt += 1
            # backward
            loss.backward()
            optimizer.step()
            lr_scheduler.step()
            optimizer.zero_grad()
            # update tqdm bar
            #progress_bar.update(len(tr_labels))
        # Eval
        acc, prec, recall, threshold_accs, threshold_precs, threshold_recalls, epoch_probs = evaluate()
        print("   [epoch {}] acc: {:.4f} precision: {:.4f} recall: {:.4f}".format(epoch+1, acc, prec, recall), flush=True)
        if acc > best_acc: # "early stopping"
            best_acc, best_prec, best_recall = acc, prec, recall
        for i, (th, th_acc, th_prec, th_recall) in enumerate(zip(positive_thresholds, threshold_accs, threshold_precs, threshold_recalls)):
            #print("    > {:.2f} acc: {:.4f} precision: {:.4f} recall: {:.4f}".format(th, th_acc, th_prec, th_recall))
            if th_acc > best_th_accs[i]: # "early stopping"
                best_th_accs[i], best_th_precs[i], best_th_recalls[i] = th_acc, th_prec, th_recall
        prob_dict["fold_{}".format(fold_idx+1)]["epoch_{}".format(epoch+1)] = epoch_probs
    print(" best acc: {:.4f} best precision: {:.4f} best recall: {:.4f}".format(best_acc, best_prec, best_recall))
    for th, best_th_acc, best_th_prec, best_th_recall in zip(positive_thresholds, best_th_accs, best_th_precs, best_th_recalls):
        print("    > {:.2f} best acc: {:.4f} best precision: {:.4f} best recall: {:.4f}".format(th, best_th_acc, best_th_prec, best_th_recall))

    # Empty Cache
    acc_list.append(best_acc)
    prec_list.append(best_prec)
    recall_list.append(best_recall)
    th_accs_list.append(best_th_accs)
    th_precs_list.append(best_th_precs)
    th_recalls_list.append(best_th_recalls)
    torch.cuda.empty_cache()

print("-------- Overall --------")
print("{} folds:".format(n_fold))
print("  avg acc: {:.4f}".format(np.mean(acc_list)))
print("  avg precision: {:.4f}".format(np.mean(prec_list)))
print("  avg recall: {:.4f}".format(np.mean(recall_list)))
avg_th_accs = np.mean(np.asarray(th_accs_list), axis=0)
avg_th_precs = np.mean(np.asarray(th_precs_list), axis=0)
avg_th_recalls = np.mean(np.asarray(th_recalls_list), axis=0)
for th, avg_th_acc, avg_th_prec, avg_th_recall in zip(positive_thresholds, avg_th_accs, avg_th_precs, avg_th_recalls):
    print("    > {:.2f} best acc: {:.4f} best precision: {:.4f} best recall: {:.4f}".format(th, avg_th_acc, avg_th_prec, avg_th_recall))
with open("../results/v5_10-folds_commit.json", "w") as f:
    json.dump(prob_dict, f)
