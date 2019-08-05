# git commit --amend

To correct your comment in the last commit:
git commit --amend
The previous commit message will be displayed in the editor. You can then change
the message and re-save. 

Note that this replaces the commit refid with a new one, e.g.

before "git commit --amend":
$ git log --oneline --max-count=5
305657a (HEAD -> master) Ouch
f050732 Resolved
3d7e5b4 (origin/chapter-two, chapter-two) Some commit
66b9078 Revert "x"
7400ad7 x

after:
$ git log --oneline --max-count=5
19e76a8 (HEAD -> master) Ouch. Corrected commit message.
f050732 Resolved
3d7e5b4 (origin/chapter-two, chapter-two) Some commit
66b9078 Revert "x"
7400ad7 x


*****************************************************************************************************
* Rewriting history is a bad practice if the commit to be reverted has already been pushed publicly *
*****************************************************************************************************

Note that we have changed history here. If we have previously "push"ed the commit ref that
we've just removed from history, we should ** NEVER ** push this new "-amend"ed branch, 
because it could seriously mess with other people using the repository. 

From https://stackoverflow.com/questions/253055/how-do-i-push-amended-commit-to-the-remote-git-repository :

"A few Git commands, like "git commit --amend" and "git rebase", actually rewrite the history 
graph. This is fine as long as you haven't published your changes, but once you do, you really 
shouldn't be mucking around with the history, because if someone already got your changes, then 
when they try to pull again, it might fail. Instead of amending a commit, you should just make 
a new commit with the changes."

On the other hand...

If you know that you are the only person pushing and you want to push an amended commit or push 
a commit that winds back the branch, you can force Git to update the remote branch by using:
git push origin +master:master		(i.e. local-branch:remote-branch)
(The leading + sign will force the push to occur, even if it doesn't result in a "fast-forward" commit.
This is basically the same as "git push -f origin master").

(See also page 110 of "Git In Practice").


JeremyC 5-8-2019
