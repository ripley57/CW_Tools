o GIT GUIs
gitg, tig (console-based)

o CHECK INTEGRITY OF REPOSITORY:
git fsck

o GIT PREVIEW 
--dry-run
-n
NOTE: This option does not apply to all git commands!

o GIT .gitinore FILE
Examples: https://github.com/github/gitignore

o CLONE AN EXISTING REPOSITORY
git clone https://github.com/ripley57/GitPlay.git
git clone https://github.com/GitInPractice/GitInPracticeRedux.git

o LIST FILES TRACKED BY GIT
git ls-files -v
H = A committed file.
h = File marked by user to be considered as unchanged.
List files NOT managed by Git:
git ls-files -o

o REMOVE ALL UNTRACKED FILES (IN WORKING DIRECTORY)
git clean --dry-run	-	Preview first. Recommended!
git clean --force	-	Force option is required because this is a destructive action!
git clean --force -d 	-	Include sub-directories.
git clean --force -X	-	Only remove ignored files (captial 'X').

o REVERT ALL NON-COMMITTED CHANGES (IN WORKING DIRECTORY)
(Example: You added some debugging statements and now you want to reset these changes.)
git reset --hard		-	Returns the working directory to the state of the last commit.
WARNING: The "--hard" option reverts all changes and you will any un-committed work!!
         This includes sub-directories!!
git reset			-	Only undoes "git add" and does not also undo any file modifications.
git reset HEAD^			-	Revert the last committed change. Use "git reset --hard" to also then 
					revert any file modifications.
git reset HEAD^ -- myfile.txt	-	Revert a particular file to the state before the last commit.

o RENAME FILES & DIRECTORIES
git mv name new-name ; git commit -m"Renamed" .
NOTE: To see the history of a renamed file:
git log --follow filename

o PUSH CHANGES TO A REMOTE REPOSITORY
Push from local master to remote master:
git push --set-upstream origin master
..this is the same as:
git push -u origin master

o TAGS
NOTE: Tags are created locally and then pushed remotely.
git tag					-	List tags.
git tag -l *v*				-	List tags matching name regexp.
git tag v1.0				-	Create a new tag locally.
git tag v1.0 -f				-	Force re-use of existing tag.
git tag v1.1 -d				-	Delete a tag.
git push --tags				-	Push tags to remote.
git checkout -b v0.1-release v0.1	-	Create a branch from a tag (and switch to it).
To auto-generate a tag name suitable for an "About" box:
git describe --tags
v1.0-1-g06178d0
This is based on the most recent tag created on this branch ("v1.0"), combined with the number of
commits since that tag was created ("1"), followed by the git commit ref, prepended with "g" for git.

o BRANCHES
A tag is similar to a branch, i.e. it's a pointer to a single commit, but the 
pointer remains pointing to the same commit even when new commits are made.
git branch			-	List current branch (http://edp-confluence.engba.vtas.com/display/DEVOPS/QA+Workflow).
git branch -a			-	List all branches including remotes (https://githowto.com/remote_branches).
git checkout V811_R1		-	Change to branch (https://githowto.com/navigating_branches).
                                       	NOTE: Specify a remote branch name here to track it and switch to a local copy.
git checkout some-branch -- hello_world.txt	-	Extract a copy of a single file from a different branch.
git checkout --force V811_R1 	-	Force switch to a new branch, overwriting any local changes!
To create a remote branch, create it locally, then "push" it:
git branch some-branch		-	You can use "git checkout -b some-branch" to combine these two steps.
git checkout some-branch
git push -u origin some-branch
List commits in some-branch that are not yet in the master branch:
git checkout some-branch
git cherry --verbose master
NOTE: "+" indicates the change is missing.

o CREATE A *LOCAL* BRANCH
In Git, a branch is no more than a pointer to a particular commit. See "git-pointers.png". 
The branch pointer moves as new commit are made on that branch. This is unlike other version 
control systems such as Subversion, in which branches are subdirectories of the repository.
NOTE: A branch cannot have spaces or (..) in the name.
git branch chapter-two
...this is equivalent to specifing the branch point explicity:
git branch chapter-two master	
..then, to list branches:
git branch
  chapter-two
* master
NOTE: "HEAD" pointer always points to the current branch.

o CREATE A *REMOTE* BRANCH
Create a local branch and then make it a remote branch:
git branch chapter-two
git checkout chapter-two			(switch to the new branch)
git push --set-upstream origin chapter-two	(push it to the remote repository named "origin")

o MERGE A BRANCH
See also git_merge.md
NOTE: A branch is always merged into the CURRENT branch.
Example: Make a commit on the local branch "chapter-two" and merge that into the master branch:
1. "git checkout chapter-two"			(ensure that we’re on the "chapter-two" branch).
2. Commit some change in the "chapter-two" branch.
3. "git checkout master" 			(check out the branch we wish to merge our changes into).
4. "git merge chapter-two" 			(perform the merge of the "chapter-two" branch into master).
git commit -i -m"Merged" . 		-	You must use "-i" to commit your manually merged changes.
						NOTE: It is preferably to not specify -m"..." here, and instead
						create a comment based on the pre-populated text, which lists 
						the file names that had conflicts. This is handy to have.
git push --delete origin chapter-two	-	Remove a remote branch.
git branch --delete chapter-two		-	Remove a local branch.
NOTE: Deleting "origin/chapter-two" first, means the local "chapter-two branch" can be deleted 
      with "git branch --delete" without Git complaining that "chapter-two" has changes that need to 
      be pushed to "origin/chapter-two".
git checkout chapter-two
git push --delete origin 
NOTE: In Git, once a branch has been merged, the history of the branch is still visible in the history, 
      and the branch can be safely deleted.

o PULL vs FETCH
git pull	-	Fetches the changes from a remote repository AND merges them into the current branch.
git fetch 	- 	Fetches the changes from a remote repository but SKIPS the merge step.
			You must do the merge manually, e.g. using "git merge origin/master".
			Note: "git status" will show you're "behind", but tTo see these (unmerged) changes, you
			need to query the working directory with the remote branch, e.g.: "git diff origin master"

o GIT BLAME
git blame [--show-email|-e] FILENAME	-	Optionally show author email address.
get blame -w FILENAME			-	Ignore whitespace changes.
git blame -s FILENAME			-	Exclude author name and the date.
git blame -L 40,60 FILENAME		-	Specify a line number range.

o GIT BISECT
This can help you quickly identify where a bad change occurred, by using a binary examination of 
your commits. Basically, you tell git where the state was "good" and where is was "bad" and git 
will automatically choose and checkout revisions for you to examine.
(See also https://americanexpress.io/git-bisect/)
WARNING: git will checkout different revisions, thereby overwriting the current state!
1. You give git a range of commits, starting from our current "bad" state, up to a known "good" state:
git bisect start HEAD 6576b6
2. We manually examine the current checkout of the files. NOTE: This is where we might run a unit test.
If the state is good, we type "git bisect good"; and if the state is bad, we type "git bisect bad". 
The next revision to examine will be checked out for usautomatically. If we are unsure about a particular 
checkout, we type "git bisect skip", and another checkout will be chosen for us to examine. 
3. We repeat step 2, examining the files each time, until we get to type "git bisect good".
Note that the "bisect" command creates temporary "bad" and "good" refs, which we can see using:
git log --oneline
4. To reset everything and remove these temporary refs:
git bisect reset
NOTE: If you already know in what files or directory the "bad" change occurred, you can use this:
git bisect start src/gui
NOTE: The manual check that you perform in step 2 can be put in a script, then run:
git bisect run ./my-test.sh
(You can exit with 125 in your script if you need to do a "git bisect skip", e.g. if that particular
checkout does not compile your test).

o GIT SHOW, GIT LOG & GIT DIFF 
git show 41b0904f278			-	Show changes in a SINGLE commit. Equivalent to "git log --max-count=1 -p".
git show branchname:filename		-	Show contents of file in a particular branch.
git show origin/branchname:filename	-	Show contents of file in a particular remote branch.
git log -p				-	Show all changes as patch diffs.
git log -- <filepath>			-	Show log history of a specific file.
git log --oneline			-	Shows first line of each commit message.
git diff --stat				-	Show a line diff stat per file, e.g. "00-Preface.txtc | 2 ++" (=2 insertions)
git diff --stat HEAD^			-	See names of files changed in the last commit.
git diff --word-diff 			-	Show word diff, e.g. "wibble [-write book-]{+Is this funny?+}"
git diff ccc6f5e..fc43842		-	Diff between two revisions.
git diff origin/inspiration		-	Diff current branch with remove branch "inspiration".
More complex examples:
git log --author "Mike McQuaid" --after "Nov 10 2013" --grep 'file\.'
git log --format=email --reverse --max-count 2
NOTE: --author 					-	Is a regexp.
NOTE: --after (--before, --since, --until) 	-	Can include: today, yesterday, Nov 10 2013 , 2014-01-30
NOTE: --grep 					-	Matches the commit message.
git log --format="%ar %an did: %s"	-	Uses the custom formatter.
git log --oneline --graph --decorate	-	Visualizes branching and merging on the console.

o  GIT STASH
Creates a temporary commit with a prepopulated commit message and then returns 
your current branch to the state before the temporary commit was made.
git stash save "My stash"	-	Create a stash. "save" is optional. You don't need to run "git add" first.
git stash list			-	List queue/stack of all stashes.
git diff stash@{0}		-	Diff of stash with working directory.
git stash pop			-	Apply stash to working directory and remove stash from queue.
git stash apply			-	Apply stash to working directory but do NOT remove stash from queue.
git stash clear			-	Remove the queue/stack of stashes.

o MARK A FILE AS UNCHANGED
This is useful is you are playing with changes to a config file, and you 
don't want your changes to be accidentally committed with other changes.
git update-index --assume-unchanged my-file		-	Flag files as unchanged.
git update-index --no-assume-unchanged my-file		-	To un-flag the file as unchanged.

o EXPAND A SHORT REF TO A FULL REF
# git rev-parse master
6b437c7739d24e29c8ded318e683eca8f03a5260
# git rev-parse 6b437c7
6b437c7739d24e29c8ded318e683eca8f03a5260

o REMOVE A FILE COMPLETELY FROM HISTORY (e.g. large file or passwords.txt)
https://help.github.com/articles/removing-sensitive-data-from-a-repository/

o USEFUL REFERENCES
http://try.github.io/
https://githowto.com
http://gitref.org/inspect/

o GITHUB PAGES
https://www.markdownguide.org/basic-syntax/
https://www.thinkful.com/learn/a-guide-to-using-github-pages/start/new-project/project-page/
http://jmcglone.com/guides/github-pages/

