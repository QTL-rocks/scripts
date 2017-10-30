## Git Command Summary
**git init**

Create an empty Git repository or reinitialize an existing one in a directory

**git clone**

Clone a repository into a new directory

**git status**

Show the working tree status

**git add**

Add changes to the staging area

*add all*

Ones can also type `git add -A.` where the dot stands for the current directory, so everything in and beneath it is added. The -A ensures even file deletions are included.

*git reset <filename>*

Remove a file or files from the staging area.
Ones also can use wildcards if he wants to add many files of the same type.(e.g: `git add "*.txt"`)

**git commit -m ”comments”**

Store the staged changes with a message describing what have been changed. 

**git log** 

Get history of all the changes have been committed so far.

*git log --summary*

See more information for each commit. It's a good overview of what's going on in the project.

**git pull**

Check for changes on the GitHub repository and pull down any new changes.

**git diff**

Show what is different from our last commit by using the git diff command. Another great use for diff is looking at changes within files that have already been staged. 

git diff with the `--staged` option to see the changes you just staged. 

**git checkout**

Files can be changed back to how they were at the last commit by using the command: `git checkout -- <target>`. 

**git branch** 

Create a branch off the master branch.
Also, ones can use git brach to see components of local branches. You can switch branches using the `git checkout <branch>` command.
Ones can use `git checkout -b new_branch` to checkout and create a branch at the same time. 
Moreover, ones can use `git branch -d <branch name>` to delete a branch after you merged the branch. 

*Force delete*

Command `-d` won't delete something that hasn't been merged. Adding the --force (-f)option or use -D which combines -d -f together into one command can force deletion.

**git rm**

Not only remove the actual files from disk, but will also stage the removal of the files.

*Remove all*

Ones can use the recursive option on git rm:`git rm -r <folder>`.This will recursively remove all folders and files from the given directory.

*The '-a' option*

If someone happens to delete a file without using 'git rm' he'll find that he still have to 'git rm' the deleted files from the working tree. Ones can save this step by using the `git commit -am "Delete stuff"` command, which auto removes deleted files with the commit.

**git merge** 

Merge changes from the snapshot branch into the master branch. 

**git push** 

Push everything you've been working on to your remote repository.
