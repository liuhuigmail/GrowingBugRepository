# README

### 任务说明

本代码使用 `./datasets-withMectrics-v3.xlsx` 中的数据划分数据集，进行二分类任务，并采用了十折交叉验证的形式验证模型效果。

输入：commit-info + 关键词过滤（保留含关键词子句）

输出：0/1标签

指标：Accuracy、Precision、Recall

模型：预训练模型 Roberta（base size），其结构为 12 层 Transformer Encoder + 2 分类头

其他：代码中默认正样本分类阈值为 0.5，同时记录更高阈值对应的相应指标



### 目录结构

```
--
 |-- code
 |   |-- dataloader.py   数据加载
 |   |-- preprocesser.py 数据处理
 |   |-- run_exp*.py     模型及训练预测脚本
 |   |-- log.txt         截图对应的完整训练log
 |-- data
 |   |-- datasets-withMectrics-v4.xlsx 实际使用数据
 |   |-- datasets-withMectrics-v3.xlsx
 |   |-- datasets-withMectrics-v2.xlsx
 |   |-- datasets-withMectrics-v1.xlsx
 |-- svm
 |   |-- run_exp_DTmetric.py  模型及训练预测脚本
```



### 环境配置

以下包需要最安装新版本，均可使用`pip install`安装

```
spacy
torch
pandas
transformers
sklearn
SNgramExtractor
pydriller
tqdm （可选）
```

此外 spacy 需要通过命令行下载模型 `python3 -m spacy download en_core_web_sm`

实验说明：配置好环境后，进入 `code` 目录运行 `python3 run_exp.py` 即可



### 代码及参数说明

#### 数据处理：spacy

在 `dataloader.py` 中使用到 spacy 的断句功能，并再次将 sub sentence 进行切分（根据逗号、分号）。切分完的子句根据关键字 `bag_of_words = ['fix', 'fixing', 'fixed', 'error', 'errors', 'bug', 'bugs', 'buggy', 'mistake', 'mistakes', 'incorrect', 'fault', 'faulty','defect', 'defects', 'flaw', 'flaws', 'repair', 'repairs', 'repaired', 'repairing']` 进行过滤，仅保留包含这些关键词（不区分大小写）的子句，并拼成新的整句作为输入。有些 sample 按上述规则过滤完后 commit-info 为空，所以在加载数据时会忽略掉这些样本。`run_exp.py` 的 67 行设定（默认 True，按上述规则进行处理）。

#### 模型：RoBERTa Base

主要使用了 huggingface-transformers 库，其中支持了若干预训练模型，可以直接在小规模下游带标签数据上进行finetune，一般情况下效果比 train from scratch 好。本次实验尝试过 bert-base-uncased、bert-base-cased、roberta-base，均为预训练的 12 层 Transformer Encoder，发现 robert-base 效果最好。huggingface 实现了相应的 Pretrain Model Class、Tokenizer、Finetune Class。

实现参考：https://huggingface.co/docs/transformers/model_doc/roberta

论文参考：https://arxiv.org/pdf/1907.11692.pdf

#### 模型训练

使用 10 折交叉验证，其中每折记录指标最好的 epoch 情况（模拟 early stopping），在 10 折后进行平均。使用单块 32GB V100 GPU 进行实验，如果 GPU 显存不够可调小 batch size。超参数在 `run_exp.py` 的 60-78 行进行设置：

```python
# Environ Hyperparams
seed = 1234 # 相同超参数以保障可复现
transformers.set_seed(seed)
os.environ["CUDA_VISIBLE_DEVICES"] = '0' # 选择 GPU
device = torch.device("cuda") if torch.cuda.is_available() else torch.device("cpu")

# Data Hyperparams
filter_keyword = True # 是否对 commit-info 进行关键词过滤
n_fold = 10 # 默认 10 折
positive_thresholds = [0.5, 0.6, 0.7, 0.8, 0.9, 0.92, 0.94, 0.96, 0.98, 0.99] # 需要监控指标的分类阈值

# Model Hyperparams
model_name = "roberta-base" #"bert-base-uncased" # 预训练模型的选择
n_class = 2 
n_epoch = 10
batch_size = 10
lr = 1e-5
lr_sche = "linear" # learning rate schedular
warmup_steps = 500 // batch_size
```

整个实验大约耗时 1h。

说明1：实验主体逻辑中不仅加载了标签、commit-info，还加载了数值特征，但这部分数值特征的使用需要重新包装一个 torch.nn.Module 类并实现其 forward() 函数。因之前实验过效果欠佳（可能由于未对数值特征进行归一化等处理），为了简洁，目前我仅保留了加载数值特征的代码。

说明2：由于单个模型大小 400M，10折交叉验证需要 4G 左右的硬盘，所以我这边没有实现模型保存和加载，如有需要可以参考 PyTorch 官网。



### Model Description

We build a neural network model, which simultaneously takes numerical features (metrics) and natural language features (commit information) of a commit as input, to learn to determine whether a commit is a buggy one. Our model consists of three parts: 1) a 12-layer Transformer encoder for modeling the commit information; 2) a 2-layer MLP for modeling the 24-dimension metrics; 3) a classifier head for merging hidden states output from 1) & 2) and making predictions. Specifically, borrowing from the NLP field, we follow the pre-training then fine-tuning paradigm and utilize the powerful pre-trained model, RoBERTa, to model the commit information. It is worth noting that the RoBERTa model will be finetuned along with other parameters. 
