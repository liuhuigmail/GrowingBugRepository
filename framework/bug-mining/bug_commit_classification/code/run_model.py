import numbers
import os
os.environ["CUDA_VISIBLE_DEVICES"] = '3'

from transformers import AutoTokenizer, AutoModel, AutoConfig
from transformers import AdamW, get_scheduler
import torch.nn.functional as F
import torch.nn as nn
import torch
import numpy as np
import json
import sys
import getopt
import csv
import warnings

from preprocesser import process_commit_info

warnings.filterwarnings("ignore")
# see https://github.com/huggingface/transformers/blob/05fa1a7ac17bb7aa07b9e0c1e138ecb31a28bbfe/src/transformers/models/roberta/modeling_roberta.py#L1438
class CommitMetricClassifier(nn.Module):
    
    def __init__(self, ptm_name, n_metric, mlp_hidden, n_class):
        super().__init__()
        # PTM part
        self.ptm_config = AutoConfig.from_pretrained(ptm_name)
        self.ptm = AutoModel.from_pretrained(ptm_name)
        # MLP part
        self.n_metric = n_metric
        self.mlp_hidden = mlp_hidden
        self.mlp = nn.Linear(n_metric, mlp_hidden)
        # Merge part
        ptm_hidden_size = self.ptm_config.hidden_size
        self.dense = nn.Linear(ptm_hidden_size + mlp_hidden, ptm_hidden_size)
        self.out_proj = nn.Linear(ptm_hidden_size, n_class)
        # dropout
        classifier_dropout = (
            self.ptm_config.classifier_dropout if self.ptm_config.classifier_dropout is not None else self.ptm_config.hidden_dropout_prob
        )
        self.dropout = nn.Dropout(classifier_dropout)

    def forward(self, ptm_inputs, mlp_inputs, labels=None):
        # PTM part
        x_ptm = self.ptm(**ptm_inputs).pooler_output
        # MLP part
        x_mlp = torch.tanh(self.mlp(self.dropout(mlp_inputs)))
        # Merge part
        x = torch.cat((x_ptm, x_mlp), 1)
        x = torch.tanh(self.dense(self.dropout(x)))
        logits = self.out_proj(self.dropout(x))
        # loss part
        if labels is None:
            return logits
        else:
            loss = F.cross_entropy(logits, labels)
            return logits, loss


# Environ Hyperparams
device = torch.device("cuda") if torch.cuda.is_available() else torch.device("cpu") 
#input arguments
project_name = None
input_file = None
output_file = None
try:
    opts, args = getopt.getopt(sys.argv[1:],"hp:i:o:")
except getopt.GetoptError:
    print("run_model.py -p <projectname> -i <inputfile> -o <outputfile>")
for opt, arg in opts:
    if opt in ['-p']:
        project_name = arg
    elif opt in ['-i']:
        input_file = arg
    elif opt in ['-o']:
        output_file = arg
    elif opt in ['-h']:
        print("helper: run_model.py -p <projectname> -i <inputfile> -o <outputfile>")
        sys.exit()
            

# Data Hyperparams
use_filtered = False
metric_norm = "minmaxlog"
n_fold = 10
positive_thresholds = [0.99]

# Model Hyperparams
model_name = "roberta-base" #"bert-base-uncased"
n_class = 2
n_epoch = 10
mlp_n_hidden = 64
batch_size = 16
lr = 1e-5
lr_sche = "linear"
warmup_steps = 1000 // batch_size

# Load  Data
fname = input_file
with open(fname, "r") as f:
    d = json.load(f)
    numbers=d["number"]
    father_versions=d["father_version"]
    commits = d["commit"]
    metrics = d["metric"]
    
n_metric = len(metrics[0])
print("[metric dimension]", n_metric)


# Load Tokenizer & Model
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = CommitMetricClassifier(model_name, n_metric, mlp_n_hidden, n_class)
num_params = 0
for param in model.parameters():
    num_params += param.numel()
print("model size", num_params, end=" ")
model.to(device)
model.load_state_dict(torch.load('saveT.pt') if torch.cuda.is_available() else torch.load('saveT.pt', map_location='cpu')  )
model.eval()

labels_list=[]

commit_eval, metric_eval =  commits, metrics
n_eval = len(commit_eval)



def process_metrics( valid_metrics, method="minmax"):
    valid_metrics = np.asarray(valid_metrics).astype(np.float)
    whole_metrics =  valid_metrics 
    if method=="minmax":
        min_metric = np.min(whole_metrics)
        max_metric = np.max(whole_metrics)
        norm_valid_metrics = (valid_metrics - min_metric) / (max_metric - min_metric)
    elif method=="minmaxlog":
        epsilon = 1e-20
        print(whole_metrics)
        min_metric = np.min(whole_metrics)
        max_metric = np.max(whole_metrics)
        norm_valid_metrics = (valid_metrics - min_metric) / (max_metric - min_metric)
        norm_valid_metrics = np.log(norm_valid_metrics + epsilon)
    else:
        assert False, "Unknown normalization method {}.".format(method)
    norm_valid_metrics = norm_valid_metrics.tolist()
    return norm_valid_metrics

# Preprocess Data 
if not use_filtered: # for the new version, preprocess is after cross-valid spliting
    commit_eval = [process_commit_info(cmt) for cmt in commit_eval]
metric_eval = process_metrics(  metric_eval, metric_norm)

for batch_idx in range((n_eval-1)//batch_size + 1):
    # prepare batch
    eval_sents = commit_eval[batch_idx*batch_size:(batch_idx+1)*batch_size]
    eval_input = tokenizer(eval_sents, padding="max_length", truncation=True, return_tensors="pt") # input_ids & attention_mask
    eval_batch = {k: v.to(device) for k, v in eval_input.items()}
    eval_metrics = metric_eval[batch_idx*batch_size:(batch_idx+1)*batch_size]

    eval_metrics = torch.from_numpy(np.asarray(eval_metrics, dtype=np.float32)).to(device)
    eval_labels = np.zeros(-batch_idx*batch_size+(batch_idx)*batch_size,dtype = int)
    eval_labels = np.asarray(eval_labels)
    # forward
    with torch.no_grad():
        outputs = model(eval_batch, eval_metrics)
    logits= outputs
    predictions = torch.argmax(logits, dim=-1).cpu().numpy()

    # statistics based on thresholds
    probs = torch.nn.functional.softmax(logits, dim=-1).cpu().numpy()
    positive_probs = probs[:, 1]

    for i, positive_threshold in enumerate(positive_thresholds):
        th_predictions = (positive_probs > positive_threshold).astype(np.int32)
        labels_list.extend(th_predictions)

print(len(labels_list))


with open(output_file,"w") as csvfile: 
    writer = csv.writer(csvfile)
    writer.writerow(['bug.id','revision.id.buggy','revision.id.fixed','report.id','report.url'])
    temp=1
    for i in range(1,len(labels_list)+1):
        if labels_list[i-1]==1:
            writer.writerow([temp,numbers[i-1],father_versions[i-1],"unknown","unknown"])
            temp=temp+1

torch.cuda.empty_cache()

