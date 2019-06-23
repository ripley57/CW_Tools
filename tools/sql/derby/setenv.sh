# Set DERBY_INSTALL
# See http://db.apache.org/derby/papers/DerbyTut/ns_intro.html#ns_intro

if [ ! -d "./lib" ]; then
    echo ERROR: ./lib not found, please run \"ant install-derby\"
    return
fi

DERBY_INSTALL=$(find $(pwd)/lib -mindepth 1 -maxdepth 1 -type d -print)
export DERBY_INSTALL

