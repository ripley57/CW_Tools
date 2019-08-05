# Git reflog & restoring a lost commit

RECOMMENDATION:
	NOTE: The easiest way to lose work is by running "git reset --hard" or "git checkout --force"
	Therefore, you should commit early and commit often.
	Commit whenever you’ve written anything useful that you don’t want to lose, and then rewrite
	your history later into small, readable commits.

	Another way to secure your data with Git is to regularly push to remote work branches that 
	you’ve agreed nobody else will commit to.  This is useful in case there is a hardware failure 
	on your machine; you can get back the data from the branch on the remote repository.

Git’s "reflog" (or reference log) is updated whenever a commit pointer is updated (like a
HEAD pointer or branch pointer).

NOTE: The reflog can only be used to see actions that were made in the Git repository on your local 
      machine. The reflog can't be "push"ed or "fetch"ed.


## Restore a lost commit: using the reflog
Any operation that acts on commits (such as "git rebase" ), rather than the working
directory (such as "git reset --hard"), is easily recoverable using git reflog for 
90 days after the changes were made.

Let's imagine that we've just used "git reset HEAD^" to remove the last commit. 

Running "git reflog" might look like this;
$ git reflog
f050732 (HEAD -> master) HEAD@{0}: reset: moving to HEAD
f050732 (HEAD -> master) HEAD@{1}: reset: moving to HEAD^
305657a HEAD@{2}: commit: Ouch

Here we can see our last commit 305657a ("Ouch"), followed by our "git reset HEAD^" command to revert
to the last-but-one commit (i.e. "HEAD^").

If we look at "git log" since we've run "git reset HEAD^", there is now no evidence of commit 305657a:
$ git log --oneline
f050732 (HEAD -> master) Resolved
3d7e5b4 (origin/chapter-two, chapter-two) Some commit
66b9078 Revert "x"
7400ad7 x

But, we can restore the commit, using 305657a found in the reflog:
$ git reset 305657a
Unstaged changes after reset:
M	build-CRLF.bat

And now we can see the commit 305657a again in the log history:
$ git log --oneline --max-count=5
305657a (HEAD -> master) Ouch
f050732 Resolved
3d7e5b4 (origin/chapter-two, chapter-two) Some commit
66b9078 Revert "x"
7400ad7 x

Finally, we can run "git reset --hard" to remove the modified change ("M    build-CRLF.bat"), and so
we've now restored the earlier removed commit 305657a.


NOTE:	Commits in the reflog that are older than 90 days and not ancestors of any other, 
	newer commit in the reflog are removed by the "git gc" command. "git gc" can be run
	manually, but it never needs to be because it’s run periodically by commands such as 
	"git fetch". In short, when you’ve removed a commit from all branches, you have 90
	days to recover the data before Git will destroy it.


JeremyC 5-8-2019
