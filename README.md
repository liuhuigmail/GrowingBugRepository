# A bug repository that keeps growing, called ***growingBugs***

Notably, each bug is composed of a buggy version, a fixed version, a concise patch (bug-fixing changes only), and one or more triggering test cases.

## Contents of growingBugs
To date, growingBugs contains 933 bugs from open-source Java projects. 

| Identifier      | Project name               | Number of bugs | Active bug ids      | Deprecated bug ids (\*) |
|-----------------|----------------------------|---------------:|---------------------|-------------------------| 
| Chart           | jfreechart                 |       26       | 1-26                | None                    |
| Cli             | commons-cli                |       39       | 1-5,7-40            | 6                       |
| Closure         | closure-compiler           |      174       | 1-62,64-92,94-176   | 63,93                   |
| Codec           | commons-codec              |       18       | 1-18                | None                    |
| Collections     | commons-collections        |        4       | 25-28               | 1-24                    |
| Compress        | commons-compress           |       52       | 1-48,50,52-54       | None                    |
| Csv             | commons-csv                |       17       | 1-17                | None                    |
| Gson            | gson                       |       18       | 1-18                | None                    |
| JacksonCore     | jackson-core               |       26       | 1-26                | None                    |
| JacksonDatabind | jackson-databind           |      112       | 1-112               | None                    |
| JacksonXml      | jackson-dataformat-xml     |        6       | 1-6                 | None                    |
| Jsoup           | jsoup                      |       93       | 1-93                | None                    |
| JxPath          | commons-jxpath             |       22       | 1-22                | None                    |
| Lang            | commons-lang               |       64       | 1,3-65              | 2                       |
| Math            | commons-math               |      106       | 1-106               | None                    |
| Mockito         | mockito                    |       38       | 1-38                | None                    |
| Time            | joda-time                  |       26       | 1-20,22-27          | 21                      |
| Dbutils         | commons-dbutils            |        2       | 1-2                 | None                    |
| Functor         | commons-functor            |        2       | 1-2                 | None                    |
| Imaging         | commons-imaging            |        9       | 1,3-4,6-8,10-11,14  | None                    |
| IO              | commons-io                 |        2       | 1,3                 | None                    |
| MShade          | maven-shade-plugin         |        5       | 3-7                 | None                    |
| Tika            | tika                       |        3       | 1,5-6               | None                    |
| Validator       | commons-validator          |        20      | 2,4,6-9,11-21,23-25 | None                    |
| Pool            | commons-pool               |        19      | 1-2,4-7,10-14,16,20-21,24,26-27,29-30| None   |
| Email           | commons-email              |        4       | 2-5                 | None                    |
| Graph           | commons-graph              |        3       | 1-3                 | None                    |
| Net             | commons-net                |        18      | 1,3,5,7,9,10,12,14-18,20-21,23-26             | None                    |
| Numbers_angle   | commons-numbers-angle  |              2 | 1-2               | None                    |
| Geometry_core   | commons-geometry-core  |              2 | 1,3               | None                    |
| MGpg            | maven-gpg-plugin       |              1 | 1               | None                    |
| Text            | commons-text           |              4 | 1-2,4-5               | None                    |


## Copyright
Notably, this bug repository is based on the well-known **Defects4J** https://github.com/rjust/defects4j. We reuse its source code as well as the bugs in **Defects4J**. The key difference is that **growingBugs** levearages **BugBuilder**[1] to exclude bug-irrelevarange changes from bug-fixing commmits automatically whereas **Defects4J** requests human experts to accomplish the same task. Consequently, **growingBugs** can keep growing automatically even ***without human intervention***.  

Under MIT License, you are free to use, modify, and distribute this repository with proper reference/citation.

[1] Yanjie Jiang, Hui Liu, Nan Niu, Lu Zhang, Yamin Hu. Extracting Concise Bug-Fixing Patches from Human-Written Patches in Version Control Systems. The 43rd International Conference on Software Engineering (ICSE), 2021 https://liuhuigmail.github.io/publishedPappers/ICSE2021.pdf
