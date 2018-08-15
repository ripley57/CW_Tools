TOOLS_DIR=$*

function jgit() {
	$TOOLS_DIR/jgit/jgit.sh $*
}

# Clone new copy of the remote repository.
function gitclone() {
    $TOOLS_DIR/jgit/jgit.sh clone https://github.com/ripley57/CW_Tools.git
}

# jgit.sh doesn't have a "pull" option, but we can use fetch and merge.
function gitpull() {
    $TOOLS_DIR/jgit/jgit.sh fetch
    $TOOLS_DIR/jgit/jgit.sh merge origin/master
}

# Pull latest changes from remote git repository.
function update() {
    if [ $(basename "$PWD") != "CW_Tools" ]; then
        echo "Error: You must run update from the CW_Tools directory."
        return
    fi
    gitpull
}
