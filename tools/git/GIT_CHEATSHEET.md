o GIT GUIs
gitg, tig (console-based)

o GIT PREVIEW 
--dry-run
-n
NOTE: This does not apply for all git commands!

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
git reset			-	Only undoes "git add" and does not also any file modifications.
WARNING: The "--hard" option reverts all changes and you will any un-committed work!!
         This includes sub-directories!!

o RENAME FILES & DIRECTORIES
git mv name new-name ; git commit -m"Renamed" .
NOTE: To see the history of a renamed file:
git log --follow filename

o PUSH CHANGES TO A REMOTE REPOSITORY
Push from local master to remote master:
	git push --set-upstream origin master
..this is the same as:
	git push -u origin master

o BRANCHES & TAGS
A tag is similar to a branch, i.e. it's a pointer to a single commit, but the 
pointer remains pointing to the same commit even when new commits are made.
git branch			-	List current branch (http://edp-confluence.engba.vtas.com/display/DEVOPS/QA+Workflow).
git branch -a			-	List all branches including remotes (https://githowto.com/remote_branches).
git checkout V811_R1		-	Change to branch (https://githowto.com/navigating_branches).
git checkout --force V811_R1 	-	Force switch to a new branch, overwiring any local changes.
git tag				-	List tags.
To create a remote branch, create it locally, then "push" it:
git branch some-branch
git checkout some-branch
git push -u origin some-branch

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
To create a local branch and then make it a remote branch:
	git branch chapter-two
	git checkout chapter-two			(switch to the new branch)
	git push --set-upstream origin chapter-two	(push it to the remote repository named "origin")

o MERGE A BRANCH
NOTE: A branch is always merged into the CURRENT branch.
Example: Make a commit on the local branch "chapter-two" and merge that into the master branch:
	1. "git checkout chapter-two"			(ensure that we’re on the "chapter-two" branch).
	2. Commit some change in the "chapter-two" branch.
	3. "git checkout master" 			(check out the branch we wish to merge our changes into).
	4. "git merge chapter-two" 			(perform the merge of the "chapter-two" branch into master).
git commit -i -m"Merged" . 		-	You must use "-i" to commit your manually merged changes.
git push --delete origin chapter-two	-	Remove a remote branch.
git branch --delete chapter-two		-	Remove a local branch.
(NOTE: Deleting "origin/chapter-two" first, means the local "chapter-two branch" can be deleted 
 with "git branch --delete" without Git complaining that "chapter-two" has changes that need to 
 be pushed to "origin/chapter-two").
git checkout chapter-two
git push --delete origin 
NOTE: In Git, once a branch has been merged, the history of the branch is still visible in the history, 
      and the branch can be safely deleted,

o PULL vs FETCH
git pull	-	Fetches the changes from a remote repository AND merges them into the current branch.
git fetch 	- 	Fetches the changes from a remote repository but SKIPS the merge step.
			You must do the merge manually, e.g. using "git merge origin/master".
			Note: "git status" will show you're "behind", but tTo see these (unmerged) changes, you
			need to query the working directory with the remote branch, e.g.: "git diff origin master"

o DIFFS  
git show 41b0904f278	-	Show changes in a commit.
git log -- <filepath>	-	Show log history of a specific file (in all branches).
git log -p		-	Show changes as patch diffs.
git diff --stat		-	Show a line diff stat per file, e.g. "00-Preface.txtc | 2 ++" (=2 insertions)
git diff --word-diff 	-	Show word diff, e.g. "wibble [-write book-]{+Is this funny?+}"

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

