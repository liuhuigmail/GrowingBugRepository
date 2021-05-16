# A bug repository that keeps growing, called ***growingBugs***

Notably, each bug is composed of a buggy version, a fixed version, a concise patch (bug-fixing changes only), and one or more triggering test cases.

## Contents of growingBugs
To date, growingBugs contains 1003 bugs from open-source Java projects. 

| Identifier      | Project name               | Number of bugs | Active bug ids      | Deprecated bug ids (\*) |
|-----------------|----------------------------|---------------:|---------------------|-------------------------| 
| Chart           | jfreechart                 |       26       | 1-26                | None                    |
| Cli             | commons-cli                |       39       | 1-5,7-40            | 6                       |
| Closure         | closure-compiler           |      174       | 1-62,64-92,94-176   | 63,93                   |
| Codec           | commons-codec              |       23       | 1-23                | None                    |
| Collections     | commons-collections        |        4       | 25-28               | 1-24                    |
| Compress        | commons-compress           |       54       | 1-54                | None                    |
| Csv             | commons-csv                |       17       | 1-17                | None                    |
| Gson            | gson                       |       18       | 1-18                | None                    |
| JacksonCore     | jackson-core               |       26       | 1-26                | None                    |
| JacksonDatabind | jackson-databind           |      112       | 1-112               | None                    |
| JacksonXml      | jackson-dataformat-xml     |        6       | 1-6                 | None                    |
| Jsoup           | jsoup                      |       93       | 1-93                | None                    |
| JxPath          | commons-jxpath             |       25       | 1-25                | None                    |
| Lang            | commons-lang               |       64       | 1,3-65              | 2                       |
| Math            | commons-math               |      106       | 1-106               | None                    |
| Mockito         | mockito                    |       38       | 1-38                | None                    |
| Time            | joda-time                  |       26       | 1-20,22-27          | 21                      |
| Dbutils         | commons-dbutils            |        2       | 1-2                 | None                    |
| Functor         | commons-functor            |        2       | 1-2                 | None                    |
| Imaging         | commons-imaging            |        9       | 1,3-4,6-8,10-11,14  | None                    |
| IO              | commons-io                 |        2       | 1,3                 | None                    |
| MShade          | maven-shade-plugin         |        5       | 3-7                 | None                    |
| Santuario       | santuario-java             |        4       | 1-4                 | None                    |
| Tika            | tika                       |        3       | 1,5-6               | None                    |
| Validator       | commons-validator          |        20      | 2,4,6-9,11-21,23-25 | None                    |
| MEar            | maven-ear-plugin           |        1       | 1                   | None                    |
| MGpg            | maven-gpg-plugin           |        3       | 1-3                 | None                    |
| Pool            | commons-pool               |        19      | 1-2,4-7,10-14,16,20-21,24,26-27,29-30| None   |
| Email           | commons-email              |        4       | 2-5                 | None                    |
| Graph           | commons-graph              |        4       | 1-4                 | None                    |
| Net             | commons-net                |        27      | 1-27                | None                    |
| Text            | commons-text               |        6       | 1-6                 | None                    |
| Numbers         | commons-numbers            |        3       | 1-3                 | None                    |

## Copyright
Notably, this bug repository is based on the well-known Defects4J https://github.com/rjust/defects4j. We reuse its source code as well as the bugs in Defects4J. 

Under MIT License, you are free to use, modify, and distribute this repository with proper reference/citation.

[1] Yanjie Jiang, Hui Liu, Nan Niu, Lu Zhang, Yamin Hu. Extracting Concise Bug-Fixing Patches from Human-Written Patches in Version Control Systems. The 43rd International Conference on Software Engineering (ICSE), 2021 https://liuhuigmail.github.io/publishedPappers/ICSE2021.pdf
