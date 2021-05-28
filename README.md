# A bug repository that keeps growing, called ***growingBugs***

Notably, each bug is composed of a buggy version, a fixed version, a concise patch (bug-fixing changes only), and one or more triggering test cases.

## Contents of growingBugs
To date, growingBugs contains 
 **`1001`** bugs
from open-source Java projects. 

|   | Project ID      | Project name               | Number of bugs | Bug IDs      | 
|-----------------|-----------------|----------------------------|---------------:|---------------------|
| 1     | Chart           | jfreechart                 |       26       | 1-26                |
| 2     | Cli             | commons-cli                |       41       | 1-5,7-42            |
| 3     | Closure         | closure-compiler           |      174       | 1-62,64-92,94-176   |
| 4     | Codec           | commons-codec              |       18       | 1-18                |
| 5     | Collections     | commons-collections        |        8       | 25-31,35               |
| 6     | Compress        | commons-compress           |       52       | 1-48,50,52-54       |
| 7     | Csv             | commons-csv                |       17       | 1-17                |
| 8     | Gson            | gson                       |       18       | 1-18                |
| 9     | JacksonCore     | jackson-core               |       26       | 1-26                |
| 10     | JacksonDatabind | jackson-databind           |      112       | 1-112               |
| 11     | JacksonXml      | jackson-dataformat-xml     |        6       | 1-6                 |
| 12    | Jsoup           | jsoup                      |       93       | 1-93                |
| 13     | JxPath          | commons-jxpath             |       22       | 1-22                |
| 14     | Lang            | commons-lang               |       73       | 1,3-65,67,69,71,73,76,80-84              |
| 15     | Math            | commons-math               |      106       | 1-106               |
| 16     | Mockito         | mockito                    |       38       | 1-38                |
| 17     | Time            | joda-time                  |       26       | 1-20,22-27          |
| 18     | Dbutils         | commons-dbutils            |        2       | 1-2                 |
| 19     | Functor         | commons-functor            |        2       | 1-2                 |
| 20     | Imaging         | commons-imaging            |        10      | 1,3-8,10-11,14  |
| 21     | IO              | commons-io                 |        19       | 1-3,5-6,8-11,13,15-18,22,25,27,29-30                |
| 22     | JXR             | maven-jxr                  |        1       | 1                   |
| 23     | MShade          | maven-shade-plugin         |        7       | 1-7                 |
| 24     | Tika            | tika                       |        7       | 1-7               |
| 25     | Validator       | commons-validator          |        21      | 1-2,4,6-9,11-21,23-25 |
| 26     | Pool            | commons-pool               |        19      | 1-2,4-7,10-14,16,20-21,24,26-27,29-30|
| 27     | Email           | commons-email              |        4       | 2-5                 |
| 28     | Graph           | commons-graph              |        3       | 1-3                 |
| 29     | Net             | commons-net                |        18      | 1,3,5,7,9,10,12,14-18,20-21,23-26             |
| 30     | Numbers_angle   | commons-numbers            |        2       | 1-2               |
| 31     | Geometry_core   | commons-geometry           |        2       | 1,3               |
| 32     | MGpg            | maven-gpg-plugin           |        1       | 1               |
| 33     | Text            | commons-text               |        4       | 1-2,4-5               |
| 34     | Tika_core            | Tika-core               |        7       | 4-6,9,11,17,20               |
| 35     | Tika_app            | Tika-app               |        2       | 1,3               |
| 36     | Shiro_core            | core               |        10       | 37,40,46,52,72,98,144,176,181,202               |
| 37     | Jena_core            | jena-core               |        1       | 2               |
| 38     | Shiro_web            | web               |        3       | 1,3,7               |

## Using GrowingBugs
Defects4J uploads complete Git reposities of the involved projects. However, with the increase of involved projects, such complete Git reposities are huge and it becomes difficult to integrate them into **GrowingBugs**. Consequently, we decide to exclude them but to provide a mechanism to download them automatically instead.

Once Defects4j is well-installed and configured, please run `repos.sh` to automatically download required Git repositories into the `project_repos` folder.

  - `./repos.sh`

Currently, we resuse all APIs of **Defects4J** (more details at  https://github.com/rjust/defects4j), and thus all applications relying on **Defects4J** could be transferred smoothly to **GrowingBugs**. 



## Copyright
Notably, this bug repository is based on the well-known **Defects4J** https://github.com/rjust/defects4j. We reuse its source code as well as the bugs in **Defects4J**. The key difference is that **growingBugs** levearages **BugBuilder**[1] to exclude bug-irrelevarange changes from bug-fixing commmits automatically whereas **Defects4J** requests human experts to accomplish the same task. Consequently, **growingBugs** can keep growing automatically even ***without human intervention***.  

Under MIT License, you are free to use, modify, and distribute this repository with proper reference/citation.

**[1] Yanjie Jiang, [Hui Liu](https://liuhuigmail.github.io/), Nan Niu, Lu Zhang, Yamin Hu. Extracting Concise Bug-Fixing Patches from Human-Written Patches in Version Control Systems. The 43rd International Conference on Software Engineering (ICSE), pp. 686-698, May, 2021 https://liuhuigmail.github.io/publishedPappers/ICSE2021.pdf**
