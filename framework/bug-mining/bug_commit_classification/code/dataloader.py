import pandas as pd
import numpy as np
import random
import json
import sys
import getopt


def read_csv(path):
    column_name = ['number', 'author', 'data', 'commit-info','father_version','src_modify_file_num','src_hunk_num',
    	'src_add_lines_num','src_delete_lines_num','test_modify_file_num','test_hunk_num','test_add_lines_num','test_delete_lines_num',
        'common_modify_file_num','common_hunk_num','common_add_lines_num','common_delete_lines_num','test_class_add_num',
        'test_class_sub_num','test_class_modify_num','test_method_add_num','test_method_sub_num','test_method_modify_num',
        'src_class_add_num','src_class_sub_num','src_class_modify_num','src_method_add_num','src_method_sub_num','src_method_modify_num'
        ]
    list_a = np.arange(len(column_name))
    csv_data = pd.read_csv(path, header=None, names=column_name, usecols=list_a)
    df = pd.DataFrame(csv_data)
    return df

def load_data(filepath):
    df = read_csv(filepath)

    # get nl input
    nl_inputs = list(df['commit-info'])
    assert not any(pd.isna(nl_inputs))
    # get sha commit input
    numbers_inputs = list(df['number'])
    assert not any(pd.isna(numbers_inputs))
    #get parent commit
    father_version_inputs = list(df['father_version'])
    assert not any(pd.isna(father_version_inputs))

    # get feat input
    other_inputs = []
    for column_name in df.columns.values:
        if column_name not in ['number', 'author', 'data', 'commit-info','father_version']:
            column_value = list(df[column_name])
            other_inputs.append(column_value)
            assert not any(pd.isna(column_value))
    other_inputs = np.asarray(other_inputs).T.tolist()
    
    assert len(numbers_inputs)==len(nl_inputs)==len(other_inputs)==len(father_version_inputs)
    return numbers_inputs[1:],father_version_inputs[1:],nl_inputs[1:],other_inputs[1:]

def load_all_data():
    df = read_csv(input_file)
    
    Y = []
    Y_Parent=[]
    X_NL = []
    X_FEAT = []
    y,y_parent,x_nl, x_feat = load_data(input_file)
    for yi,yi_parent,xi_nl, xi_feat in zip(y,y_parent,x_nl, x_feat):
        Y.append(yi)
        Y_Parent.append(yi_parent)
        X_NL.append(xi_nl)
        X_FEAT.append(xi_feat)

    assert len(Y)==len(X_NL)==len(X_FEAT)==len(Y_Parent)
    print('[Data Size]', len(Y))
    return Y, Y_Parent,X_NL, X_FEAT

if __name__=="__main__":

    #input arguments
    project_name = None
    input_file = None
    output_file = None
    try:
        opts, args = getopt.getopt(sys.argv[1:],"hp:i:o:")
    except getopt.GetoptError:
        print("dataloader.py -p <projectname> -i <inputfile> -o <outputfile>")
    for opt, arg in opts:
        if opt in ['-p']:
            project_name = arg
        elif opt in ['-i']:
            input_file = arg
        elif opt in ['-o']:
            output_file = arg
        elif opt in ['-h']:
            print("helper: dataloader.py -p <projectname> -i <inputfile> -o <outputfile>")
            sys.exit()
            
    numbers,father_versions,commits, metrics = load_all_data()
    # Saved to the outputfile.
    dump_dict = {"number":numbers,"father_version":father_versions,"commit": commits, "metric":  metrics}
    with open(output_file, "w") as f:
        json.dump(dump_dict, f)

