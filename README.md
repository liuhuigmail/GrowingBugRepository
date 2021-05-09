# A bug repository that keeps growing

## Contents of this BugRepository
This bug repository contains 835 bugs from the following open-source projects:

| Identifier      | Project name               | Number of bugs | Active bug ids      | Deprecated bug ids (\*) |
|-----------------|----------------------------|---------------:|---------------------|-------------------------| 
| Chart           | jfreechart                 |       26       | 1-26                | None                    |
| Cli             | commons-cli                |       39       | 1-5,7-40            | 6                       |
| Closure         | closure-compiler           |      174       | 1-62,64-92,94-176   | 63,93                   |
| Codec           | commons-codec              |       18       | 1-18                | None                    |
| Collections     | commons-collections        |        4       | 25-28               | 1-24                    |
| Compress        | commons-compress           |       47       | 1-47                | None                    |
| Csv             | commons-csv                |       16       | 1-16                | None                    |
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

## Copyright
Notably, this bug repository is based on the well-known Defects4J https://github.com/rjust/defects4j. We reuse its source code as well as the bugs in Defects4J. 
Currently, we also reuse its APIs (but no guarantee that such APIs would not be changed in the near future). The major difference is that we implement BugBuilder proposed by Jiang et al. [1], and leverage it to extract concise patches fully automatically whereas Defects4J depends on human experts to exclude bug-irrelevant changes from patches. As a result, our repository keeps growing automatically.

Under MIT License, you are free to use, modify, and distribute this repository with proper reference/citation.

[1] Yanjie Jiang, Hui Liu, Nan Niu, Lu Zhang, Yamin Hu. Extracting Concise Bug-Fixing Patches from Human-Written Patches in Version Control Systems. The 43rd International Conference on Software Engineering (ICSE), 2021 https://liuhuigmail.github.io/publishedPappers/ICSE2021.pdf
