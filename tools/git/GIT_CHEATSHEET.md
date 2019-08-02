o Git UIs for Linux:
gitg, qgit, gitk, tig (console-based)

o Clone a repository:
git clone https://github.com/ripley57/GitPlay.git

o Revert all local changes:
git reset HEAD^ --hard

o Remove all untracked changes:
Preview: git clean -n
Remove:  git clean -f

o Branches & Tags
git branch		-	List current branch (http://edp-confluence.engba.vtas.com/display/DEVOPS/QA+Workflow)
git branch -a		-	List all branches (https://githowto.com/remote_branches)
git checkout V811_R1	-	Change branch (https://githowto.com/navigating_branches)
git tag			-	List tags

o Add a remote repository, named locally as "my-new-origin":
git remote add my-new-origin https://github.com/ripley57/GitPlay.git
(NOTE: Running a "git clone" will name the remote repository as "origin").
You can have multiple repositories linked to your local repository:
git remote --verbose
my-new-origin	https://github.com/ripley57/GitPlay.git (fetch)
my-new-origin	https://github.com/ripley57/GitPlay.git (push)
my-new-origin-2	https://github.com/ripley57/GitPlay.git (fetch)
my-new-origin-2	https://github.com/ripley57/GitPlay.git (push)
my-new-origin-3	https://github.com/ripley57/GitPlay.git (fetch)
my-new-origin-3	https://github.com/ripley57/GitPlay.git (push
To work with one of these:
git push --set-upstream my-new-origin-2 master
Running "git status" will now confirm the one you are working with:
git status 
On branch master
Your branch is up-to-date with 'my-new-origin-2/master

o "git pull" vs "git fetch"
git pull	-	Fetches the changes from a remote repository AND merges them into the current branch.
git fetch 	- 	Fetches the changes from a remote repository but SKIPS the mmerge step
			You must do the merge manually, e.g. using "git merge origin/master"
			Note: "git status" will show you're "behind". To see these (unmerged) changes: "git diff origin/master"
			(Remember: "git diff origin/master" shows the differences between the current working tree state and 
			the "origin" remote’s master branch.)

o  Diffs
git show 41b0904f278	-	Show changes in a commit.
git log -- <filepath>	-	Show log history of a specific file (in all branches).
git log -p		-	Show changes as patch diffs.
git diff --stat		-	Show line diff stats, per file, e.g. "00-Preface.txtc | 2 ++" (=2 insertions)
git diff --word-diff 	-	Show word diff, e.g. "TODO: [-write book-]{+Is this funny?+}"

o Expand a short ref to full ref, examples:
# git rev-parse master
6b437c7739d24e29c8ded318e683eca8f03a5260
# git rev-parse 6b437c7
6b437c7739d24e29c8ded318e683eca8f03a5260

o Remove a file completely from history (e.g. large file or passwords.txt)
https://help.github.com/articles/removing-sensitive-data-from-a-repository/

o USEFUL REFERENCES:
http://try.github.io/
https://githowto.com
http://gitref.org/inspect/

o GITHUB PAGES:
https://www.markdownguide.org/basic-syntax/
https://www.thinkful.com/learn/a-guide-to-using-github-pages/start/new-project/project-page/
http://jmcglone.com/guides/github-pages/

