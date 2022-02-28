import re
from pydriller import Repository


def get_num_of_hunk(files):
    '''
    返回修改的代码块
    :param files:
    :return:
    '''
    # print(files)
    res = 0
    for file in files:
        lines = file.split('\n')
        for line in lines:
            if len(line) > 2 and line[0:2] == '@@' and line.count('@@') == 2:
                res += 1
    return res


def get_num_of_delete(files):
    '''
    返回删除的文件（类）数
    :param files:
    :return:
    '''
    res = 0
    for file in files:
        lines = file.split('\n')
        for line in lines:
            if line.startswith('-') and not line.startswith('---'):
                new_line = line[1:].lstrip()
                if not (new_line.startswith('*') or new_line.startswith('/*') or new_line.startswith('//')):
                    res += 1
    return res


def get_num_of_add(files):
    '''
    返回增加的文件（类）数
    :param files:
    :return:
    '''
    res = 0
    for file in files:
        lines = file.split('\n')
        for line in lines:
            if line.startswith('+') and not line.startswith('+++'):
                new_line = line[1:].lstrip()
                if not (new_line.startswith('*') or new_line.startswith('/*') or new_line.startswith('//')):
                    res += 1
    return res


def get_all_name_of_files(files):
    '''
    获取所有的文件名(diff --git 开头)
    :param files:
    :return:
    '''
    res = []
    for file in files:
        lines = file.split('\n')
        for index in range(0, len(lines)):
            if lines[index].startswith('diff --git'):
                res.append(lines[index])
    return res


def spilt_codes(content):
    '''
    将diff分解为对应的不同的文件
    :param content:
    :return:
    '''
    files = []
    temp = ''
    lines = content.split('\n')
    for index in range(0, len(lines)):
        if lines[index].startswith('diff --git'):
            if temp != '':
                files.append(temp)
                temp = ''
        temp += lines[index] + '\n'
    if temp != '':
        files.append(temp)
    return files


def get_common_metrics(files):
    modify_file_nums = len(files)
    num_of_hunks = get_num_of_hunk(files)
    num_of_add_lines = get_num_of_add(files)
    num_of_delete_lines = get_num_of_delete(files)

    return [modify_file_nums, num_of_hunks, num_of_add_lines, num_of_delete_lines]


# 计算增加类的数量、减少类的数量，改动类的数量
def get_java_class_metrics(files):
    modify_class_num = len(files)
    add_class_num = 0
    sub_class_num = 0
    for file in files:
        lines = file.split('\n')
        for line in lines:
            if line[0:3].startswith('+++') and 'null' in line:
                sub_class_num += 1
            if line[0:3].startswith('---') and 'null' in line:
                add_class_num += 1
    return [add_class_num, sub_class_num, modify_class_num - add_class_num - sub_class_num]


def method_filter(file_names, all_methods, all_methods_before):
    class_names = []
    new_all_methods = []
    new_all_methods_before = []
    for file_name in file_names:
        class_names.append(file_name.split(' ')[-1].split('/')[-1].split('.')[0])
    for method in all_methods:
        if method.split('::')[0] in class_names:
            new_all_methods.append(method)
    for method in all_methods_before:
        if method.split('::')[0] in class_names:
            new_all_methods_before.append(method)
    return new_all_methods, new_all_methods_before


def judge_add_or_delete_method(all_methods, all_methods_before):
    add = 0
    sub = 0
    for am in all_methods:
        if am not in all_methods_before:
            add += 1
    for amb in all_methods_before:
        if amb not in all_methods:
            sub += 1
    return add, sub


def get_java_method_metrics(files, project_path, version):
    # 获取测试java文件的所有文件名
    file_names = get_all_name_of_files(files)
    num_of_add_method = 0
    num_of_sub_method = 0
    num_of_modify_method = 0

    def is_in(name, names):
        for index in range(0, len(names)):
            if name in names[index]:
                return index
        return -1
    for commit in Repository(project_path, single=version).traverse_commits():
        for m in commit.modified_files:
            # 查看提交文件的文件名是否属于测试文件
            index = is_in(m.filename, file_names)
            if index != -1:
                changed_methods = []
                for method in m.changed_methods:
                    changed_methods.append(method.name)
                num_of_modify_method += len(list(set(changed_methods)))
                # 得到所有修改了的方法名
                all_methods = []
                for method in m.methods:
                    all_methods.append(method.name)
                all_methods_before = []
                for method in m.methods_before:
                    all_methods_before.append(method.name)
                all_methods, all_methods_before = method_filter(file_names, all_methods, all_methods_before)
                # 确定连续修改多个行数的修改块的第一个大括号前的语句是否包含在这些方法名中
                add, sub = judge_add_or_delete_method(all_methods, all_methods_before)
                num_of_add_method += add
                num_of_sub_method += sub

    return [num_of_add_method, num_of_sub_method, num_of_modify_method - num_of_add_method - num_of_sub_method]


def analysis(content, project_path, version):
    # with open(file_path, 'r') as f:
    files = spilt_codes(content)
    test_files = []
    src_files = []
    other_files = []
    for file in files:
        head = file.split('\n')[0]
        if head[-5:] != '.java':
            other_files.append(file)
        else:
            if 'test' in head.lower():
                test_files.append(file)
            else:
                src_files.append(file)
    result = []
    result += get_common_metrics(src_files) + get_common_metrics(test_files) + get_common_metrics(other_files)\
              + get_java_class_metrics(test_files) + get_java_method_metrics(test_files, project_path, version)\
              + get_java_class_metrics(src_files) + get_java_method_metrics(src_files, project_path, version)

    return result


if __name__ == '__main__':
    # result = analysis('../testFile/1a4bea73.txt')
    # print(
    #     'src common metrics:{}\n'.format(result[0:4]),
    #     'test common metrics:{}\n'.format(result[4:8]),
    #     'other common metrics:{}\n'.format(result[8:12]),
    #     'test class java metrics:{}\n'.format(result[12:15]),
    #     'test mathod java metrics:{}\n'.format(result[15:18]),
    #     'src class java metrics:{}\n'.format(result[18:21]),
    #     'src method java metrics:{}\n'.format(result[21:24])
    # )
    # get_common_metrics('../testFile/111.txt')
    metrics = ['src_modify_file_num', 'src_hunk_num', 'src_add_lines_num', 'src_delete_lines_num',
               'test_modify_file_num', 'test_hunk_num', 'test_add_lines_num', 'test_delete_lines_num',
               'common_modify_file_num', 'common_hunk_num', 'common_add_lines_num', 'common_delete_lines_num',
               'test_class_add_num', 'test_class_sub_num', 'test_class_modify_num',
               'test_method_add_num', 'test_method_sub_num', 'test_method_modify_num',
               'src_class_add_num', 'src_class_sub_num', 'src_class_modify_num',
               'src_method_add_num', 'src_method_sub_num', 'src_method_modify_num']

