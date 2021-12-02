This is the guidance for bug-mining, it will be updated later.
# Overview of the bug-mining process

1. Configure the projects for bug mining.

2. Modify the script to configure bug-mining working directory and text file which has stored the mining information.

3. Run the script to mine the bug.

4. Check the mining result.

5. Promote all reproducible minimized bugs to the main database!

## Configure the projects for bug mining

Suppose we want to mine reproducible bugs from the
[Apache Commons Codec](https://commons.apache.org/proper/commons-codec/)
project.

Firstly, create a text file to store the general properties, also you can use [exapmle.txt](https://github.com/liuhuigmail/GrowingBugRepository/blob/main/framework/bug-mining/example.txt).
Next, define the general properties of the projects in the file line by line. For the Apache Commons Codec project, these are:

```bash
Codec	commons-codec	https://github.com/apache/commons-codec.git	jira	CODEC	/(CODEC-\\d+)/mi	.	
```
Note: please split each word by `\t` rather than blank space.

Here are the details about the general properties above from left to right sequentially.

- The **project id** (i.e., `PROJECT_ID`) should **start with an upper-case letter**
  and should be **short yet descriptive** (keep in mind that this id is used for
  commands such as `defects4j checkout -p <PROJECT_ID>`).
  Considering the project may consists of several modules(we call it subproject), the project id can be named as `project_subproject`.
- The **project name** (`PROJECT_NAME`) must not include spaces, but can be
  hyphenated. For example, the project name for the Apache Commons-Lang project,
  already included in Defects4J, is *commons-lang*, and its project id is *Lang*.
  Similarly, for subproject,  the project name can be `project-subproject`.
- The **issue tracker id** (`ISSUE_TRACKER_NAME`) identifies the issue tracker
  for the project you are interested in. Defects4j's bug-mining framework
  supports the following issue trackers:
    - [google-code](https://code.google.com/) ('google' for short)
    - [jira](https://issues.apache.org/jira/)
    - [github](https://github.com)
    - [sourceforge](https://sourceforge.net/) ('sf' for short)
    - [bugzilla](https://www.bugzilla.org) 
- The **issue tracker project id** (`ISSUE_TRACKER_PROJECT_ID`) is the project
  identifier used in the issue tracker. For example, the issue tracker project
  id for the Apache Commons-Lang project is *LANG*.
- The **bug fix regex** is a Perl regular expression that matches bug-fixing
  commits (e.g., issue numbers, keywords, etc.), e.g., `/(LANG-\\d+)/mi` matches
  all bug-fixing commits of the Apache Commons-Lang project. Note that the
  regular expression has to capture the issue number.
- The **sub project** is a relevant path that matches the project's module,
  e.g., if the project exists the dictionary named `tika-core` 
  which can be regarded as a module, you can set `tika-core` or `./tika-core` as the sub project option .
  Note that if you want to mine a common project,
  you just need to input `.` as default configuration. 
  
  The following table reports the issue trackers, issue tracker project IDs, and
regular expressions previously used in `GrowingBugRepository` (note that we manually built
the `active-bugs.csv` for Chart):

| Project ID | Issue tracker | Issue tracker project ID | Regexp                    | Sub project            |
|------------|---------------|--------------------------|---------------------------|---------------------------|
| Chart      |               |                          |                           | .                         |
| Closure    | google        | closure-compiler         | `/issue[^\\d]*(\\d+)/mi`    | .                         |
| Lang       | jira          | LANG                     | `/(LANG-\\d+)/mi`          | .                        |
| Time       | github        | JodaOrg/joda-time        | `/Fix(?:es)?\s*#(\\d+)/mi` | .                        |
| Tika_core       |jira       | TIKA        | `/(TIKA-\\d+)/mi` | 	tika-core       |

Please refer to [bug_mining_projects_info.txt](https://github.com/liuhuigmail/GrowingBugRepository/blob/main/framework/bug-mining/bug_mining_projects_info.txt) for details.

## Modify the script to configure bug-mining working directory and text file which has stored the mining information

Once all projects and their own properties have been defined, the
[execute-run-by-bug.sh](https://github.com/liuhuigmail/GrowingBugRepository/blob/main/framework/bug-mining/execute-run-by-bug.sh) should be modified.
The context from line 2 to line 4 is shown as below:

```bash
WORK_DIR="bug-mining"
echo "WORK_DIR: $WORK_DIR"
cat example.txt | while read line 
```
What you need to do is to chanhge `bug-mining` to the working directory you want to use and change `example.txt` to the text file you used in step1.


## Run the script to mine the bug

Based on the step1 and step2, the `execute-run-by-bug.sh` should be executed as:

```bash
./execute-run-by-bug.sh 
```

## Check the mining result

After `execute-run-by-bug.sh` has finished, you can check the working :

```bash
./execute-run-by-bug.sh 
```
