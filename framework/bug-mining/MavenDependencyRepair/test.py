import re
import filecmp
import argparse
from filediff.diff import file_diff_compare

if __name__ == '__main__':
    # 设置参数
    ap = argparse.ArgumentParser()
    ap.add_argument("-o", "--origin", required=True, help="origin dependency file")
    ap.add_argument("-t", "--target", required=True, help="target dependency file")
    args = vars(ap.parse_args())
    # # 获取参数并且打印出来
    # print(type(args))
    # print(args)
    file_diff_compare(args['origin'], args['target'], diff_out='diff_result.html', max_width=70, numlines=0, show_all=False, no_browser=False)
