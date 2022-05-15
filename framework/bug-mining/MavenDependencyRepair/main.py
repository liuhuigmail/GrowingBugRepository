import requests
import json
import re
import os
import argparse


try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET

POM_NS = "{http://maven.apache.org/POM/4.0.0}"


# class CommentedTreeBuilder(ET.TreeBuilder):
#     def comment(self, data):
#         self.start(ET.Comment, {})
#         self.data(data)
#         self.end(ET.Comment)


def modifyPOM(args):
    pom_path = args["path"]
    # parser = ET.XMLParser(target=CommentedTreeBuilder())
    # tree = ET.parse(pom_path, parser=parser)
    # tree = ET.parse(pom_path, parser = CommentedTreeBuilder() )

    tree = ET.parse(pom_path)
    root = tree.getroot()

    for child in root.iter('%sdependency' % (POM_NS)):
        group_id = child.find('%sgroupId' % POM_NS)
        artifact_id = child.find('%sartifactId' % POM_NS)
        version = child.find('%sversion' % POM_NS)
        if group_id is None or artifact_id is None or version is None:
            continue

        # 排除掉类似${springframework.version}的依赖或者是以SNAPSHOT结尾的依赖
        if re.match(r"^[\$\{].*\}$", version.text) is not None:
            continue

        rest_api = "https://search.maven.org/solrsearch/select?q=g:{}+AND+a:{}&core=gav&rows=20&wt=json".format(group_id.text, artifact_id.text)
        f = requests.get(rest_api)
        # print(f.content)
        json_data = json.loads(bytes.decode(f.content, 'utf-8'))
        # print(json_data)
        if 'response' in json_data:
            response = json_data['response']
        else:
            continue
        if 'docs' in response:
            docs = response['docs']
        else:
            continue
        # print(docs)
        exist_versions = []
        for doc in docs:
            if '.pom' in doc['ec'] and 'v' in doc:
                exist_versions.append(doc['v'])
        # print(exist_versions)

        # 如果当前版本在maven仓库里可以找到的话直接跳过
        if version.text in exist_versions:
            continue

        if version.text.count('.', 0) == 1:
            main_version = version.text.split(".")[0]
            subversion = version.text.split(".")[1]
        elif version.text.count('.', 0) == 2:
            main_version = version.text.split(".")[0]
            subversion = version.text.split(".")[1]
            stage_version = version.text.split(".")[2]
        else:
            print("{}.{} has wrong version format!".format(group_id, artifact_id))
            continue

        # 首先看是否能够能够找到对应的主版本号
        main_version_newest = None
        main_version_flag = 0
        subversion_newest = None
        subversion_flag = 0
        for v in exist_versions:
            if v.split(".")[0] == main_version and main_version_flag == 0:
                main_version_newest = v
                main_version_flag = 1
                if v.split(".")[1] == subversion and subversion_flag == 0:
                    subversion_newest = v
                    subversion_flag = 1

        if subversion_newest is not None:
            print("group_id: {}, artifact_id: {} has been modified! exist_version: {}. all_versions: {}".format(
                group_id.text, artifact_id.text, version.text, exist_versions))
            version.text = subversion_newest
            continue

        if main_version_newest is not None:
            print("group_id: {}, artifact_id: {} has been modified! exist_version: {}. all_versions: {}".format(
                group_id.text, artifact_id.text, version.text, exist_versions))
            version.text = main_version_newest
            continue

        for v in reversed(exist_versions):
            if int(v.split(".")[0]) < int(version.text.split(".")[0]):
                continue
            else:
                print("group_id: {}, artifact_id: {} has been modified! exist_version: {}. all_versions: {}".format(
                    group_id.text, artifact_id.text, version.text, exist_versions))

                version.text = v
                break

    # 将最终的结果写回文件当中
    tree.write(pom_path)

    s = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    with open(pom_path, 'r') as file:
        s += file.read()
        s = s.replace("ns0:", "").replace(":ns0", "")
        # print(s)
        file.close()

    with open(pom_path, 'w') as file:
        file.write(s)
        file.close()


if __name__ == '__main__':
    # 设置参数
    ap = argparse.ArgumentParser()
    ap.add_argument("-p", "--path", required=True,help="path to the dependency file")
    args = vars(ap.parse_args())
    # # 获取参数并且打印出来
    # print(type(args))
    # print(args)
    # try:
    modifyPOM(args)
    print("OK")
    # except Exception as result:
    #     print("ERROR %s" % result)
