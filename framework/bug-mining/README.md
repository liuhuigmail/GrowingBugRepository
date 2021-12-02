This is the guidance for bug-mining, it will be updated later.
# Overview of the bug-mining process

1. Initialize a bug-mining working directory and configure the projects for bug mining.

2. Run the script to mine the bug.

3. Check the mining result.

4. Promote all reproducible minimized bugs to the main database!

## Initialize a bug-mining working directory and configure the projects for bug mining

Suppose we want to mine reproducible bugs from the
[Apache Commons Codec](https://commons.apache.org/proper/commons-codec/)
project.

Firstly, create text file txt to store the general properties, 
Next, define the general properties of the project. For the Apache Commons Codec project, these are:

```bash
Codec	commons-codec	https://github.com/apache/commons-codec.git	jira	CODEC	/(CODEC-\\d+)/mi	.	
```
Here are the details about the general properties above from left to right sequentially.

- The **project id** (i.e., `PROJECT_ID`) should **start with an upper-case letter**
  and should be **short yet descriptive** (keep in mind that this id is used for
  commands such as `defects4j checkout -p <PROJECT_ID>`).
- The **project name** (`PROJECT_NAME`) must not include spaces, but can be
  hyphenated. For example, the project name for the Apache Commons-Lang project,
  already included in Defects4J, is *commons-lang*, and its project id is *Lang*.
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
  commits (e.g., issue numbers, keywords, etc.), e.g., `/(LANG-\d+)/mi` matches
  all bug-fixing commits of the Apache Commons-Lang project. Note that the
  regular expression has to capture the issue number.
