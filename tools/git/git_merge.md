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


JeremyC 5-8-2019
