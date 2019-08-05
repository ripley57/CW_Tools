# Git revert

To revert a change:
git revert c18c9ef

NOTE: Reverting a previous git ref, like this, simply reverts the changes made to the
      files that were updated in that commit. It does NOT affect any other files. 
      For example, if any new files were added after the commit, reverting to before 
      the commit does not remove these new files.

NOTE: Another good reason to keep your commits small as possible.

From what I can see, reverting to an older commit is likely to leave you with merge
conflicts that you'll need to resolve manually. This is because they're likely to
be further changes made to the file(s) since the commit.

NOTE: See also "git reset" 


JeremyC 5-8-2019

