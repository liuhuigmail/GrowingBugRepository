from cgi import print_directory
from distutils import command
import os
import numpy as np
import subprocess
import pandas as pd
import sys
import re
from AnalyseDiff import analysis
import getopt
import warnings
warnings.filterwarnings("ignore")

bag_of_words = ['fix', 'fixing', 'fixed', 'error', 'errors', 'bug', 'bugs', 'buggy', 'mistake', 'mistakes', 'incorrect', 'fault', 'faulty',
                'defect', 'defects', 'flaw', 'flaws', 'repair', 'repairs', 'repaired', 'repairing']


def read_csv(path):
    """
    get the the commit-info of the project
    :param project: the name of the project
    :return: commit-info of the project
    """
    column_name = ['number', 'author', 'data', 'commit-info']
    list_a = np.arange(4)
    csv_data = pd.read_csv(path, header=None, names=column_name, usecols=list_a)
    df = pd.DataFrame(csv_data)
    return df


def judge_fix_commit(sentence):
    # print(type(sentence))
    pattern1 = re.compile(r"[`';.]\s*")
    sentences = re.split(pattern1, sentence)

    pattern2 = re.compile(r"[`':;,.\s]\s*")
    for s in sentences:
        words = re.split(pattern2, s)
        words = [word.lower() for word in words]
        # words_list = ['#' + word.lower() for word in words_list]
        bag_of_words_list = [word.lower() for word in bag_of_words]
        while '' in words:
            words.remove('')
        for i in range(0, len(words)):
            if words[i] in bag_of_words_list:
                return True
    return False


def find_father_version(project_path, version):
    # 切换当前的工作目录
    # os.chdir(project_path)
    # 找到父版本的命令
    command = 'git '+' --git-dir=' + project_path  + ' rev-list --parents -n 1 ' + version
    platform = sys.platform
    #print(command)
    out = None
    if "win" in platform:
        p = subprocess.Popen(command,
                             stdin=subprocess.PIPE,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, shell=True)
        out = p.stdout.read().decode('utf-8')
        out = out[:-1]
    elif "linux" in platform:
        p = subprocess.Popen(command,
                             stdin=subprocess.PIPE,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, shell=True)
        out = p.stdout.read().decode('utf-8')
    # os.chdir(sys.path[0]) 
    father_list = out.split(' ')[1:]
    father_list=[x.replace('\n','') for x in father_list]
    # print(father_list)
    return father_list


def find_diff(project_path, cur_version, father_version):
    command = 'git  -C ' + project_path + ' diff %s ' % father_version + '%s' % cur_version
    # print(command)
    platform = sys.platform
    diff = None
    if "win" in platform:
        p = subprocess.Popen(command,
                             stdin=subprocess.PIPE,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, shell=True)
        diff = p.stdout.read().decode('utf-8')
    elif  "linux" in platform:
        p = subprocess.Popen(command,
                             stdin=subprocess.PIPE,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, shell=True)
        diff = p.stdout.read().decode('utf-8')
        # print(diff)
    return diff


def get_commit_log(project_path):
    command = '''git  -C ''' + project_path + ''' log --date=iso --pretty=format:\'\"%H\",\"%an\",\"%ad\",\"%s\"\' > ./data/''' + project+'''_log.csv'''
    platform = sys.platform 
    log = None
    #print(command)
    if "win" in platform:
        p = subprocess.Popen(command,
                             stdin=subprocess.PIPE,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, shell=True)
        log = p.stdout.read().decode('utf-8')
        p.stdout.close()
    elif  "linux" in platform:
        p = subprocess.Popen(command,
                             stdin=subprocess.PIPE,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, shell=True)
        log = p.stdout.read().decode('utf-8')
    return log

if __name__ == '__main__':

    #input arguments
    project_name = None
    repositorypath = None
    output_file = None
    try:
        opts, args = getopt.getopt(sys.argv[1:],"hp:r:o:")
    except getopt.GetoptError:
        print("GetFeature.py -p <projectname> -r <repositorypath> -o <outputfile>")
    for opt, arg in opts:
        if opt in ['-p']:
            project_name = arg
        elif opt in ['-r']:
            repositorypath = arg
        elif opt in ['-o']:
            output_file = arg
        elif opt in ['-h']:
            print("helper: GetFeature.py -p <projectname> -r <repositorypath> -o <outputfile>")
            sys.exit()

    project = project_name
    project_path = repositorypath#+".git"
    get_commit_log(project_path)    
    df = read_csv('./data/' + project+'_log.csv') 
    df['father_version'] = ''
    metrics = ['src_modify_file_num', 'src_hunk_num', 'src_add_lines_num', 'src_delete_lines_num',
               'test_modify_file_num', 'test_hunk_num', 'test_add_lines_num', 'test_delete_lines_num',
               'common_modify_file_num', 'common_hunk_num', 'common_add_lines_num', 'common_delete_lines_num',
               'test_class_add_num', 'test_class_sub_num', 'test_class_modify_num',
               'test_method_add_num', 'test_method_sub_num', 'test_method_modify_num',
               'src_class_add_num', 'src_class_sub_num', 'src_class_modify_num',
               'src_method_add_num', 'src_method_sub_num', 'src_method_modify_num']
    
    platform = sys.platform
    for metric in metrics:
        df[metric] = 0
    # 新建一个new_df存储数据
    new_df = df.copy()
    new_df.drop(new_df.index, inplace=True)
    new_df = new_df.drop(index=new_df.index)    
    for index, row in df.iterrows():
        try:
            if not judge_fix_commit(row['commit-info']):
                continue
            father_versions = find_father_version(project_path, row['number'])
            for father_version in father_versions:
                diff = find_diff(project_path, row['number'], father_version) 
                res = analysis(diff, project_path, row['number'])
                for i in range(0, len(res)):
                    row[metrics[i]] = res[i]
                row['father_version'] = father_version
                new_df = new_df.append(row) #warning
        except:
             continue
    new_df.to_csv(output_file, index=None)
