TOOLS_DIR=$*

# Description:
#   Download and install a pre-installed Node.js environment, which 
#   was created# by the install_nodejs function. That function takes
#   several minutes to complete, so this should be a quicker way to get 
#   a working Node.js environment.
#
# Usage:
#   install_nodejs_preinstalled
#
function install_nodejs_preinstalled() {
    if [ "$1" = '-h' ]; then
        usage install_nodejs_preinstalled
        return
    fi

    download_file "$DOWNLOAD_NODEJS_PREINSTALLED" "node.zip"
    unzip node.zip
    find ./node -iname node.exe -o -iname npm.cmd -exec chmod +x {} \;

    echo
    echo You might now want to run "run_nodejs_demos"
}

# Description:
#   Run Node.js demos.
#
#   This function is intended to be run after running the
#   install_nodejs function.
#
# Usage:
#   run_nodejs_demos
#
function run_nodejs_demos() {
    	if [ "$1" = '-h' ]; then
        	usage run_nodejs_demos
        	return
    	fi

	echo "Creating \"Hello world\" test program in demo.js..."
	cat >demo.js <<EOI
	console.log('')
	console.log('Hello world!')
EOI
	cmd /c .\\node.exe demo.js

	echo
	echo "Running encryption demo..."
	nodejs_encryption_demo
	
	echo
	echo "Running csvtojson demo..."
	cat >example.csv <<EOI
id,name,address
3,fred,england
5,bert,wales
EOI
	cmd /c .\\csvtojson example.csv
}

# Description:
#   Create a local portable Node.js development environment in the specified directory.
#
#   Based on steps from:
#   https://codyswartz.us/wp/finds/node-js-stand-alone-portable-with-npm
#   https://gist.github.com/massahud/321a52f153e5d8f571be
#
#   This also installs:
#
#   o csvtojson
#     Converts a csv file to json formatted data, e.g.:
#        csvtojson example.csv > example.json
#
#   o http-server
#     Simple web server. To launch, create a "public" directory 
#     containing the files to serve, then start the server:
#        http-server -p 8888
#
#   Note: These commands should be run from a Windows command prompt, or
#         in Cygwin using something like the following:
#            cmd /c .\\node.exe demo.js
#
# Usage:
#   install_nodejs <dirname>
#
# Example usage:
#   mkdir tmp1
#   install_nodejs tmp1
#
function install_nodejs() {
    	if [ "$1" = '-h' -o $# -ne 1 ]; then
        	usage install_nodejs
        	return
    	fi
	
	local _dirname="$(cygpath -aw "$1")"
	
	if [ -f "$_dirname" ]; then
		echo "ERROR: Directory already exists: $_dirname. Aborting..."
		return
	fi
	
	mkdir -p "$_dirname" || ( \
		echo "ERROR: Failed to created directory: $_dirname. Aborting..."
		return
	)
	local _pwd=$(PWD)
	cd "$_dirname"
	
	echo "Downloading Node.js ..."
    	download_file "https://nodejs.org/dist/v8.11.3/node-v8.11.3-win-x64.zip" "nodejs.zip"
	if [ ! -f "nodejs.zip" ]; then
		echo "ERROR: Failed to download Node.js. Aborting..."
		cd "$_pwd"
		return
	fi
	
	echo "Downloading npm ..."
	download_file "https://github.com/npm/npm/archive/v6.1.0.zip" "npm.zip"
	if [ ! -f "npm.zip" ]; then
		echo "ERROR: Failed to download npm.zip. Aborting..."
		cd "$_pwd"
		return
	fi
	
	echo "Extracting node.exe from nodejs.zip ..."
	/usr/bin/unzip nodejs.zip node-v8.11.3-win-x64/node.exe 2>&1 >/dev/null
	if [ ! -f "node-v8.11.3-win-x64/node.exe" ]; then
		echo "ERROR: Failed to extract node.exe from nodejs.zip. Aborting..."
		cd "$_pwd"
		return
	fi
	cp node-v8.11.3-win-x64/node.exe .
	# Tidy up.
	rm -fr node-v8.11.3-win-x64
	rm -f nodejs.zip
	
	echo "Creating node_modules folder ..."
	mkdir -p node_modules
	echo "Extracting npm.zip into node_modules/ ..."
	/usr/bin/unzip -q npm.zip -d node_modules/ 2>&1 >/dev/null
	if [ ! -d "node_modules/npm-6.1.0" ]; then
		echo "ERROR: Failed to extract npm.zip. Aborting..."
		cd "$_pwd"
		return
	fi
	# Rename the extracted folder.
	mv node_modules/npm-6.1.0 node_modules/npm
	# Tidy up.
	rm -f npm.zip
	echo "Copying npm.cmd to current directory..."
	cp node_modules/npm/bin/npm.cmd .
	
	# Run npm installers.
	chmod +x npm.cmd node.exe
	cmd /c .\\npm.cmd install -g express
	cmd /c .\\npm.cmd install express --save
	
	# Install some extra modules that are useful.
	cmd /c .\\npm.cmd i --save csvtojson
	cmd /c .\\npm.cmd install http-server -g

	run_nodejs_demos
	
	echo
	echo "Node.js installation complete!"
}


# Description:
#   Run an encryption demo Node.js program.
#
# Usage:
#   run_nodejs_encryption_demo
#
# Example usage:
#	nodejs_encryption_demo
#
function nodejs_encryption_demo() {
    if [ "$1" = '-h' ]; then
        usage nodejs_encryption_demo
        return
    fi

	if [ ! -f node.exe ]; then
		echo "ERROR: Run this function from the directory containing node.exe. Aborting..."
		return
	fi

	cp ${TOOLS_DIR}/javascript/nodejs/encryption-demo.js .
	cmd /c .\\npm.cmd install crypto-js 2>&1 >/dev/null
	cmd /c .\\node.exe encryption-demo.js
}

# Description:
#   AES encrypt a binary file.
#	This will create a file named <input-file>.encrypted
#
# Usage:
#   nodejs_encrypt_file <password> <file1 file2 ...>
#
# Example:
#	nodejs_encrypt_file "hello world" image.png
#
function nodejs_encrypt_file() {
    if [ "$1" = '-h' ]; then
        usage nodejs_encrypt_file
        return
    fi

	if [ ! -f node.exe ]; then
		echo "ERROR: Run this function from the directory containing node.exe. Aborting..."
		return
	fi

	cp ${TOOLS_DIR}/javascript/nodejs/encrypt-file.js .
	cmd /c .\\node.exe encrypt-file.js "$password" encrypt $*
}

# Description:
#   AES decrypt a binary file.
#	This will create a file named <input-file>.decrypted
#
# Usage:
#   nodejs_decrypt_file <password> <file>
#
# Example:
#	nodejs_decrypt_file image.png.encrypted
#
function nodejs_decrypt_file() {
    if [ "$1" = '-h' ]; then
        usage nodejs_decrypt_file
        return
    fi

	if [ ! -f node.exe ]; then
		echo "ERROR: Run this function from the directory containing node.exe. Aborting..."
		return
	fi

	cp ${TOOLS_DIR}/javascript/nodejs/encrypt-file.js .
	cmd /c .\\node.exe encrypt-file.js "$password" decrypt $*
}

# Description:
#   base64 encode a binary file.
#	This will create a file named <input-file>.base64_encoded
#
# Usage:
#   nodejs_base64_encode_file <file>
#
# Example:
#	nodejs_base64_encode_file image.png
#
function nodejs_base64_encode_file() {
    if [ "$1" = '-h' ]; then
        usage nodejs_base64_encode_file
        return
    fi

	if [ ! -f node.exe ]; then
		echo "ERROR: Run this function from the directory containing node.exe. Aborting..."
		return
	fi

	cp ${TOOLS_DIR}/javascript/nodejs/base64-encode-file.js .
	cmd /c .\\node.exe base64-encode-file.js encode $*
}

# Description:
#   base64 decode a binary file.
#	This will create a file named <input-file>.base64_decoded
#
# Usage:
#   nodejs_base64_decode_file <file>
#
# Example:
#	nodejs_base64_decode_file image.png.base64_encoded
#
function nodejs_base64_decode_file() {
    if [ "$1" = '-h' ]; then
        usage nodejs_base64_decode_file
        return
    fi

	if [ ! -f node.exe ]; then
		echo "ERROR: Run this function from the directory containing node.exe. Aborting..."
		return
	fi

	cp ${TOOLS_DIR}/javascript/nodejs/base64-encode-file.js .
	cmd /c .\\node.exe base64-encode-file.js decode $*
}
