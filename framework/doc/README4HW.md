This is the guidance of bug-mining.The first part is about setting up GrowingBugs, the second part is about the bug-mining process.  
#  Set up GrowingBugRepository
## Requirements
 - Java 1.8
 - Git >= 1.9
 - SVN >= 1.8
 - Perl >= 5.0.12
 - Curl
 
## Steps to set up GrowingBugs
1. Initialize GrowingBugs:

    Download the project repositories and external libraries that are not included in the git repository for size purposes and to avoid redundancies. We provide a mechanism to download them automatically as follows:
    - Unzip GrowingBugRepository.zip 
    - `cd GrowingBugRepository` %get into the root to the unzipped GrowingBugRepository.zip 
    - `cpanm --installdeps .` % intall some Perl library 

    
2. Add GrowingBugs's executables to your PATH:
    - `export PATH=$PATH:"path2growingbugs"/framework/bin`

##  Using GrowingBugs
1. Checkout a buggy source code version (If the project doesn't hava subproject, `-s` parameter can be ignored):
    - `defects4j checkout -p project_id -v version_id -w work_dir -s subproject_name` 
    
    Example:
  
    - `defects4j checkout -p Shiro_core -v 2b -w /tmp/Shiro_core_37_buggy -s core`
    - `defects4j checkout -p Collections -v 2b -w /tmp/Collections_2_buggy -s  .`

   Notably, **GrowingBugs**  supports sub-projects that are not suported by Defects4J. To this end, yor should specify the sub-project with  `-s` parameter in the `checkout`  command. The preceding example common leverages `-s core` to check out sub-proejct `core` from the enclosing project `Shiro_core`. For the `compile` and `test` commands, you should also switch to the sub-project's folder to compile and test the sub-project.

2. Change to the working directory, compile sources and tests, and run tests:

   - `cd work_dir/subproject_name`
   - `defects4j compile`
   - `defects4j test`
   
   Example1：
   
   - `cd /tmp/Shiro_core_37_buggy/core`
   - `defects4j compile`
   - `defects4j test`

   Example2：
   
   - `cd /tmp/dbutils_1_buggy`
   - `defects4j compile`
   - `defects4j test`

Currently, we resuse all APIs of **Defects4J** (more details at  https://github.com/rjust/defects4j), and thus all applications relying on **Defects4J** could be transferred smoothly to **GrowingBugs**. 


# Overview of the bug-mining process

 **Before execute bug-mining process, please ensure that `GrowingBugRepository` has been configured already(refer to [README.md](https://github.com/liuhuigmail/GrowingBugRepository/blob/main/README.md)).**

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
Codec commons-codec https://github.com/apache/commons-codec.git jira CODEC /(CODEC-\\d+)/mi . 
```
Note: please split each word by `\t` rather than blank space.

Here are the details about the general properties above from left to right sequentially.

- The **project id** (i.e., `PROJECT_ID`) should **start with an upper-case letter**
  and should be **short yet descriptive** (keep in mind that this id is used for
  commands such as `defects4j checkout -p <PROJECT_ID>`).
  Considering the project may consists of several modules(we call it subproject), the project id can be named as `project_subproject`.
- The **project name** (`PROJECT_NAME`) must not include spaces, but can be
  hyphenated. For example, the project name for the Apache Commons-Lang project,
  already included in GrowingBugRepository, is *commons-lang*, and its project id is *Lang*.
  Similarly, for subproject,  the project name can be `project-subproject`.
- The **issue tracker id** (`ISSUE_TRACKER_NAME`) identifies the issue tracker
  for the project you are interested in. GrowingBugRepository's bug-mining framework
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

## Modify the script to configure

Once all projects and their own properties have been defined, the
[execute-run-by-bug.sh](https://github.com/liuhuigmail/GrowingBugRepository/blob/main/framework/bug-mining/execute-run-by-bug.sh) should be modified.
The context from line 2 to line 4 is shown as below:

```bash
WORK_DIR="bug-mining"
echo "WORK_DIR: $WORK_DIR"
cat example.txt | while read line 
```
What you need to do is to change `bug-mining` to the working directory you want to use and change `example.txt` to the text file you used in previous step.


## Run the script to mine the bug

Based on the previous steps, the `execute-run-by-bug.sh` should be executed as:

```bash
./execute-run-by-bug.sh 
```

## Check the mining result

After the script `execute-run-by-bug.sh` finished, please check the `$WORK_DIR\$project id\minimum_patches` file,
all the successful bugs' patches will be store in it
(**successful bug** means that is has as least one trigger test, and its src patch is concise). 

## Promoting reproducible bugs to the main database

For each fault, if the diff is minimal (i.e., does not include features or
refactorings), promote the fault to the main `GrowingBugRepository` database.

```bash
./promote-to-db.pl -p $PROJECT_ID \
                   -w $WORK_DIR \
                   -r $WORK_DIR/project_repos/$PROJECT_NAME.git \
                   -b <bid>
```

For example, if you want to first `Codec` bug, and your working directory is `bug-mining`, you can run as:
```bash
./promote-to-db.pl -p "Codec" \
                   -w "bug-mining/Codec" \
                   -r "bug-mining/Codec/project_repos/commons-codec.git" \
                   -b 3
```

Note: Make sure to specify the `-b` option as the default is to promote all
bugs!

## Troubleshooting

* If you encounter the following error when running `./execute-run-by-bug.sh`:

   ```
  Can't locate JSON/Parse.pm in @INC (you may need to install the JSON::Parse module)
   ```
   - Make sure that you have installed all of the perl dependencies listed in [cpanfile](https://github.com/liuhuigmail/GrowingBugRepository/blob/main/cpanfile). As mentioned in the top-level [README](https://github.com/liuhuigmail/GrowingBugRepository/blob/main/README.md), these can automatically installed by running: `cpanm --installdeps .`
   
## Limitations of the bug-mining framework

- Although some scripts in the bug-mining framework are agnostic to the version
  control system used by a project and even support different version control
  systems, there are some other scripts that are Git dependent.
- If a project uses more than one issue tracker only one can be mined.
- Although the `Mockito` project in `GrowingBugRepository` database uses
  [Gradle](https://gradle.org/) as its build system, the current bug-mining
  framework only supports [Apache Ant](https://ant.apache.org/) and
  [Apache Maven](https://maven.apache.org/).
