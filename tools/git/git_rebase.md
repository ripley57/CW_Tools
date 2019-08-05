# Rebasing commits on top of another branch - git rebase

This is effectively "cherry-picking" the changes on one branch and applying
each of them to another branch. It's similar to merging but requires rewriting 
history.

A rebase involves changing the parent of a commit to point to another commit.

ME: I believe this involves "rewriting history" because the hash value of a commit
is based on its parent. Therefore, if you change a parent (due to rebasing), you
also change all the children. (The fact that the hash of a commit is based on its
parent is one of things that gives git its reliability). You'll often see warnings
that rewriting history is a bad thing, but, if the changes you're rebasing have
never been in a public repository until now, then I see no problem with this, 
because nobody will have any references to the old (pre-rebase) commit refs.

From page 112 of "Git In Practice":
"The argument to "git rebase" can be any ref. You could rebase on an arbitrary commit,
but this is generally a bad idea. You should usually rebase on top of either an updated
branch or a different branch/tag".

From https://dev.to/maxwell_dev/the-git-rebase-introduction-i-wish-id-had :
You might want to do this (rebase), for example, when you're ready to merge some changes 
that you've been working on in a branch, but the master branch has moved on a lot since 
you started your work. 

Example (rebasing on master branch):
git checkout master
git pull			(Get latest remote changes)
git checkout my-dev-branch	(Switch to your dev branch)
git rebase master		(Rebase your changes on top of the latest master branch)

If you're lucky, there won't be any merge conflicts. Otherwise you'll need to use
"git rebase --continue". See page 113, and the link above again.

The rebase itself technically removes your old commits and makes new commits identical 
to them. 

Here's an example where I made some changes on a branch ("some-branch") and then
rebased this to the master branch:

git rebase master
First, rewinding head to replay your work on top of it...
Applying: e1
Applying: e2


## git rebase --interactive	(interactively rebase the history of a branch)
From page 117 of "Git In Practice":
"I typically always use an interactive rebase before I push a branch upstream; it allows 
me to take stock and consider what I want the history to look like. The factors I consider 
are whether any commits are now redundant or only cleaning up previous commits, whether 
any commit messages can be improved, whether any commits need to be reordered to make more 
sense..."

TBC: SO, you'd create some temporary local branch, rebase your dev branch into this
temporary branch, changing the comments etc as you want, then finally push this temporary
branch to the remote?


JeremyC 5-8-2019
