TOOLS_DIR=$*

# Description:
#   Useful git commands and links.
#
# Usage:
#   githelp
#
function githelp() {
    if [ "$1" = '-h' ]; then
        usage githelp
        return
    fi
	cat <<EOI

o Generate a token for Git access:
python3.5 git-credential-vtas-stash.pex -p https -H stash.vtas.com -l -u jeremy.c get-token

o Clone CW repository:
git clone https://jeremy.c@stash.vtas.com/scm/edp/esa-src

o Revert all local changes:
git reset HEAD^ --hard

o Remove all untracked changes:
Preview: git clean -n
Remove:  git clean -f

o Download any changes:
git pull

o Determining current branch (http://edp-confluence.engba.vtas.com/display/DEVOPS/QA+Workflow):
git branch
	
o List branches (https://githowto.com/remote_branches):
git branch -a 	
	
o Change branch (https://githowto.com/navigating_branches):
git checkout V811_R1

o List tags:
git tag

o Checkout tag (into an existing cloned repository):
git fetch
git checkout <tag-name>

o Changes in a commit, example:
git show 41b0904f278

o Show log history of a specific file (in all branches):
git log -- <filepath>

o Remove a file completely from history (e.g. large file or passwords.txt)
https://help.github.com/articles/removing-sensitive-data-from-a-repository/

o Vtas Git client setup steps:
https://confluence.community.vtas.com/pages/viewpage.action?title=Getting+Started+with+GIT&spaceKey=BCH

Useful references:
http://try.github.io/
https://githowto.com
http://gitref.org/inspect/

Github pages:
https://www.thinkful.com/learn/a-guide-to-using-github-pages/start/new-project/project-page/
http://jmcglone.com/guides/github-pages/
Markdown cheatsheet:
http://packetlife.net/media/library/16/Markdown.pdf

EOI
}
