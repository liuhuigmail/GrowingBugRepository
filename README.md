# A bug repository that keeps growing, called ***growingBugs***

Notably, each bug is composed of a buggy version, a fixed version, a concise patch (bug-fixing changes only), and one or more triggering test cases.

## Contents of growingBugs
To date, growingBugs contains 937 bugs from open-source Java projects. 

| Identifier      | Project name               | Number of bugs | Bug IDs      | 
|-----------------|----------------------------|---------------:|---------------------|
| Chart           | jfreechart                 |       26       | 1-26                |
| Cli             | commons-cli                |       39       | 1-5,7-40            |
| Closure         | closure-compiler           |      174       | 1-62,64-92,94-176   |
| Codec           | commons-codec              |       18       | 1-18                |
| Collections     | commons-collections        |        4       | 25-28               |
| Compress        | commons-compress           |       52       | 1-48,50,52-54       |
| Csv             | commons-csv                |       17       | 1-17                |
| Gson            | gson                       |       18       | 1-18                |
| JacksonCore     | jackson-core               |       26       | 1-26                |
| JacksonDatabind | jackson-databind           |      112       | 1-112               |
| JacksonXml      | jackson-dataformat-xml     |        6       | 1-6                 |
| Jsoup           | jsoup                      |       93       | 1-93                |
| JxPath          | commons-jxpath             |       22       | 1-22                |
| Lang            | commons-lang               |       64       | 1,3-65              |
| Math            | commons-math               |      106       | 1-106               |
| Mockito         | mockito                    |       38       | 1-38                |
| Time            | joda-time                  |       26       | 1-20,22-27          |
| Dbutils         | commons-dbutils            |        2       | 1-2                 |
| Functor         | commons-functor            |        2       | 1-2                 |
| Imaging         | commons-imaging            |        9       | 1,3-4,6-8,10-11,14  |
| IO              | commons-io                 |        2       | 1,3                 |
| MShade          | maven-shade-plugin         |        5       | 3-7                 |
| Tika            | tika                       |        3       | 1,5-6               |
| Validator       | commons-validator          |        20      | 2,4,6-9,11-21,23-25 |
| Pool            | commons-pool               |        19      | 1-2,4-7,10-14,16,20-21,24,26-27,29-30|
| Email           | commons-email              |        4       | 2-5                 |
| Graph           | commons-graph              |        3       | 1-3                 |
| Net             | commons-net                |        18      | 1,3,5,7,9,10,12,14-18,20-21,23-26             |
| Numbers_angle   | commons-numbers  |              2 | 1-2               |
| Geometry_core   | commons-geometry  |              2 | 1,3               |
| MGpg            | maven-gpg-plugin       |              1 | 1               |
| Text            | commons-text           |              4 | 1-2,4-5               |

## Copyright
Notably, this bug repository is based on the well-known **Defects4J** https://github.com/rjust/defects4j. We reuse its source code as well as the bugs in **Defects4J**. The key difference is that **growingBugs** levearages **BugBuilder**[1] to exclude bug-irrelevarange changes from bug-fixing commmits automatically whereas **Defects4J** requests human experts to accomplish the same task. Consequently, **growingBugs** can keep growing automatically even ***without human intervention***.  

Under MIT License, you are free to use, modify, and distribute this repository with proper reference/citation.

[1] Yanjie Jiang, Hui Liu, Nan Niu, Lu Zhang, Yamin Hu. Extracting Concise Bug-Fixing Patches from Human-Written Patches in Version Control Systems. The 43rd International Conference on Software Engineering (ICSE), 2021 https://liuhuigmail.github.io/publishedPappers/ICSE2021.pdf
