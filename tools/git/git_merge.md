# Git Merges

## Fast-Forward merge vs a "merge commit"
[Nice explanation of a Fast-Forward merge](https://ariya.io/2013/09/fast-forward-git-merge)

This happens when you merge-in a branch to a branch where no changes had been made since, i.e.
the incoming branch has the current branch as an ancestor, and commits have been made on the
incoming branch, but none have been made on the current branch since the incoming branch was
branched from it.

The prevents a "merge commit" from being created.
NOTE: It's better to have merge commits, since they leave an explicit indication of the merge,
      including metadata such as who performed the merge, when, and why.

To create a "merge commit", by preventing a Fast-Forward merge:
git merge --no-ff chapter-spacing

We can now delete the branch:
git branch --delete chapter-spacing

NOTE: I've done this with and without using "-no-ff", and when you don't use "-no-ff" you
end up with no historical indication that there was a branch that was merged from! 
WITH "-no-ff", you get an extra commit point for the merge, plus GUIs including "gitg" 
give an indication visually of there having been a branch present.


## Merging "strategies"
The default/implicit when merging a single branch:
git merge --strategy=recursive

NOTE: You CAN merge multiple branches at once, but this will fail if there are merge
conflicts. This implicitly uses the merging strategy "octopus". Because merge conflicts
will cause the merge to fail, it's usually best to merge one branch at a time.

For more details, see page 88 of "Git In Practice".


## Merge conflicts
Note that, after manually resolving a merge conflict, and committing the change, the
history indicates that it was a "Merge", and includes the refs of the merged files:

$ git show 618c632
commit 618c6320fceabff476b6ed7bb55a9292ae56fc8d (HEAD -> master)
Merge: 3604fa8 4c69a1d
Author: Bob Smith <bob.smith@gmail.com>
Date:   Mon Aug 5 12:23:52 2019 +0100


## Graphical merge tools (git mergetool)
Tools include: "emerge", "gvimdiff", "kdiff3", "meld", "vimdiff", "opendiff", or "tortoisemerge".
See "git help mergetool"
Example:
git mergetool --tool=kdiff3

Simply use the "A, B, C" buttons in the toolbar to choose the final output you want, then click 
the save button.


## Re-playing a recorded merge resolution (git rerere)
You may often have to merge one branch into another, and you might always get the same
merge conflicts that you need to resolve manually. You can automate this by recording
the resolution and re-applying it automatically.

See "kdiff3-merge-conflict-Linux-Mint.png" for an example, showing a single file with a
single conflicting line. Here we are merging from the remote branch "chapter-two" (tracked 
to a local "chapter-two" branch) to the local master branch.

To enable (for all repositories):
git config --global --add rerere.enabled 1

Future commits will now be recorded. When you next perform a  "git merge", you should see
"Resolved ... using previous resolution". Note that you still need to run "git add" and 
"git commit -i" to accept the conflict resolution.

To forget a resolution:
git rerere forget 01-IntroducingGitInPractice.asciidoc


## git cherry-pick
The classic use case is back-porting bug fixes from a development branch to a stable branch.
It’s effectively duplicating specific commits. (If you cherry-pick many commits from a branch
then it's probably better to do a merge instead).

Example: If dfe2377 is a bug fix commit on a development branch, and you want to apply it to
the current branch:
git cherry-pick dfe2377

You can use a tag name instead:
git cherry-pick v1.0-release

You can also specify multiple refs.
Include --edit to add a message.


JeremyC 5-8-2019
