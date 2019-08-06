# git rebase

Remember!
**********************************************************************************************
* Rewriting history is a bad practice if the involved commits have been previously published *
**********************************************************************************************

Rebasing is effectively picking a range of commits from one branch and applying
them to another branch. It's similar to merging, but requires rewriting history,
because it creates new commit refs. This can be very dangerous if the new commits
are then published but other users are using repositories referencing the old 
commit refs.

From page 112 of "Git In Practice":
"The argument to "git rebase" can be any ref; you could rebase on an arbitrary commit,
but this is generally a bad idea. You would usually rebase on top of either an updated
branch (see also "git pull --rebase" below) or a different branch/tag".

From https://dev.to/maxwell_dev/the-git-rebase-introduction-i-wish-id-had :
You might want to do this (rebase), for example, when you're ready to merge some changes 
that you've been working on in a branch, but the master branch has moved on a lot since 
you started your work. 

Example:
git checkout master		(Switch to master branch)
git pull			(Get latest remote changes)
git checkout my-dev-branch	(Switch to your dev branch)
git rebase master		(Rebase your dev changes on top of the master branch)
This adds any changes to master to your dev branch, and then re-applies your dev
changes on top. You dev branch is now up to date with master.

If you're lucky, there won't be any merge conflicts. Otherwise you'll need to use
"git rebase --continue". See page 113 of "Git In Practice". Also see link above again.


## git rebase --interactive	(interactively rebase the history of a branch)
See example on page 114 of "Git In Practice":
git rebase --interactive v0.1
This example rebases the commits made on a branch "inspiration" since tag "v0.1", onto 
the commit point of the tag "v0.1". This example demonstrates that a particular commit
ref (a tag in this example) can be chosen as the point from which to take the range of
commits to rebase. This example is effectively re-applying the commits back onto the
the same branch, giving us a chance to edit them in the process. For example, the 
interactive steps chosen in the example, merge two of the commits together, and skip 
an empty commit, so afterwards the number of commits on the branch is two less. Not 
used in this example, there exists an interactive "command" to re-edit commit comments.

Before: before-rebase.png
After:  after-rebase.png

NOTE: It's described as "interactive", but it's only interactive if you select
      one of the "commands" such as "r" to re-edit the comment of a commit.

From "Git In Practice":
"I typically always use an interactive rebase before I push a branch upstream; it allows 
me to take stock and consider what I want the history to look like. The factors I consider 
are whether any commits are now redundant or only cleaning up previous commits, whether 
any commit messages can be improved, whether any commits need to be reordered to make more 
sense"

NOTE: It's easy to scrap your rebase changes and start again - see below.


## Undoing a rebase
Use "git reflog" to determine the "HEAD@{n}" n value before the rebase occurred.
Then run "git reset --hard HEAD@{n}"
(See https://stackoverflow.com/questions/134882/undoing-a-git-rebase#135614)


## RECOMMENDED: Merge branches using "git pull --rebase"
If you've made changes on your branch, and you then want to pull new commits from upstream,
this will result in a "merge commit" being created (i.e. rather than a fast-forward merge 
with no additional commit ref generated). This which will make the commit history of your 
branch look a little messy. To prevent a "merge commit", you can use "git pull --rebase". 

See the example on page 117 of "Git In Practice".

What "git pull --rebase" does is merge the changes from the remote branch, and then apply 
your local commits on top. Hence no merge commit, resulting in a cleaner history.

NOTE: From "Git In Practice":
"git pull --rebase" is sometimes recommended as a sensible default to use instead of
"git pull". You’ll rarely want to create a merge commit on a git pull operation, so
using "git pull --rebase" guarantees that this won’t happen. This means when you do
push this local branch, it will have a simpler, cleaner history. Once you understand 
how torebase and solve conflicts, I recommend using "git pull --rebase" by default.


JeremyC 5-8-2019
