import spacy 
import numpy as np

bag_of_words = ['fix', 'fixing', 'fixed', 'fixes', 'error', 'errors', 'bug', 'bugs', 'buggy', 'mistake', 'mistakes', 'incorrect', 'fault', 'faulty',
                'defect', 'defects', 'flaw', 'flaws', 'repair', 'repairs', 'repaired', 'repairing']
seperators = [', ', '; ', ': ', '. ', ' - ']

nlp = spacy.load("en_core_web_sm")
def process_commit_info(text):
    # 1. split sentences
    doc = nlp(text)
    sents = [str(sent) for sent in doc.sents]
    for seperator in seperators:
        sub_sents = []
        for sent in sents:
            while sent != '':
                idx = sent.find(seperator)
                if idx != -1:
                    sub_sent = sent[:idx+1]
                    sent = sent[idx+1:]
                else:
                    sub_sent = sent
                    sent = ''
                sub_sents.append(sub_sent)
        sents = sub_sents
    sents = [sent for sent in sents if sent.strip()!=""]
    # 2. delete those not including keywords
    kept_sents = []
    for sent in sents:
        tokens = set([str(token).lower() for token in nlp(sent)])
        for word in bag_of_words:
            if word in tokens:
                kept_sents.append(sent)
                break
    # 3. space tokenize and combine sentences
    tokens = []
    for sent in kept_sents:
        tokens += sent.split()
    new_text = ' '.join(tokens)
    return new_text

def process_metrics(train_metrics, valid_metrics, method="minmax"):
    train_metrics = np.asarray(train_metrics)
    valid_metrics = np.asarray(valid_metrics)
    assert train_metrics.shape[1] == valid_metrics.shape[1]
    whole_metrics = np.concatenate((train_metrics, valid_metrics), axis=0)
    if method=="minmax":
        min_metric = np.min(whole_metrics, axis=0)
        max_metric = np.max(whole_metrics, axis=0)
        norm_train_metrics = (train_metrics - min_metric) / (max_metric - min_metric)
        norm_valid_metrics = (valid_metrics - min_metric) / (max_metric - min_metric)
    elif method=="minmaxlog":
        epsilon = 1e-20
        min_metric = np.min(whole_metrics, axis=0)
        max_metric = np.max(whole_metrics, axis=0)
        norm_train_metrics = (train_metrics - min_metric) / (max_metric - min_metric)
        norm_train_metrics = np.log(norm_train_metrics + epsilon)
        norm_valid_metrics = (valid_metrics - min_metric) / (max_metric - min_metric)
        norm_valid_metrics = np.log(norm_valid_metrics + epsilon)
    else:
        assert False, "Unknown normalization method {}.".format(method)
    norm_train_metrics = norm_train_metrics.tolist()
    norm_valid_metrics = norm_valid_metrics.tolist()
    return norm_train_metrics, norm_valid_metrics

if __name__=="__main__":
    from dataloader import load_cross_validation_split
    labels_folds, commits_folds, metrics_folds = load_cross_validation_split()
    
    # check commit-info process
    fold = 4
    labels, commits, metrics = labels_folds[fold-1], commits_folds[fold-1], metrics_folds[fold-1]
    for label, commit, metric in zip(labels, commits, metrics):
        print(commit)
        print(process_commit_info(commit))
        print()

    # check metric process
    valid_fold = 4
    train_metrics = []
    for fold_idx in range(10):
        if fold_idx != valid_fold-1:
            train_metrics += metrics_folds[fold_idx]
    valid_metrics = metrics_folds[valid_fold-1]
    norm_train_metrics, norm_valid_metrics = process_metrics(train_metrics, valid_metrics)
    for i in range(2):
        print(train_metrics[i])
        print(norm_train_metrics[i])
        print(valid_metrics[i])
        print(norm_valid_metrics[i])
        print()
