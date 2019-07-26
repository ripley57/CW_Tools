TOOLS_DIR=$*


# Description:
#   Wrapper function for the NodeJS "http-server" command.
#
#   Without any argument, this will start a web server 
#   serving the files in the current directory.
#
#   This command will download and install nodejs, if not
#   done already, into CW_Tools/tools/javascript/nodejs.
#
# Usage:
#   http-server [dir-of-files-to-serve]
#
function http-server() {
    if [ "$1" = '-h' ]; then
        usage http-server
        return
    fi

    [ ! -f "$TOOLS_DIR/javascript/nodejs/node_modules/http-server/bin/http-server" ] && install_nodejs

    printf "\nLaunching CW_Tools http-server wrapper ...\n"
    "$TOOLS_DIR/javascript/nodejs//node_modules/http-server/bin/http-server" $*
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
#   install_nodejs [<dirname>]
#
# Example usage:
#   mkdir tmp1
#   install_nodejs tmp1
#
function install_nodejs() {
    	if [ "$1" = '-h' ]; then
        	usage install_nodejs
        	return
    	fi
	
	local _dirname="$(_cygpath -aw "$1")"
        [ -z "$_dirname" ] && _dirname="$TOOLS_DIR/javascript/nodejs/"
	mkdir -p "$_dirname" || (echo "ERROR: Failed to create directory: $_dirname. Aborting..." && return)

	local _pwd=$PWD
	cd "$_dirname"
	
	echo "Downloading Node.js ..."
	if isLinux ; then
		if [ ! -f node ]; then
			download_file "https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x64.tar.gz" "nodejs.tar.gz"
			[ ! -f "nodejs.tar.gz" ] && echo "ERROR: Failed to download nodejs.tar.gz. Aborting..." && cd "$_pwd" && return

			echo "Extracting node from nodejs.tar.gz ..."
			tar xvzf nodejs.tar.gz node-v8.11.3-linux-x64/bin/node 2>&1 >/dev/null
			[ ! -f "node-v8.11.3-linux-x64/bin/node" ] && echo "ERROR: Failed to extract node from nodejs.tar.gz. Aborting..." && cd "$_pwd" && return
			cp node-v8.11.3-linux-x64/bin/node .
		fi
	else
		if [ ! -f node.exe ]; then
    			download_file "https://nodejs.org/dist/v8.11.3/node-v8.11.3-win-x64.zip" "nodejs.zip"
			[ ! -f "nodejs.zip" ] && echo "ERROR: Failed to download nodejs.zip. Aborting..." && cd "$_pwd" && return

			echo "Extracting node.exe from nodejs.zip ..."
			/usr/bin/unzip nodejs.zip node-v8.11.3-win-x64/node.exe 2>&1 >/dev/null
			[ ! -f "node-v8.11.3-win-x64/node.exe" ] && echo "ERROR: Failed to extract node.exe from nodejs.zip. Aborting..." && cd "$_pwd" && return
			cp node-v8.11.3-win-x64/node.exe .
		fi
	fi

	if [ ! -d node_modules/npm ]; then
		echo "Downloading npm.zip ..."
		download_file "https://github.com/npm/npm/archive/v6.1.0.zip" "npm.zip"
		[ ! -f "npm.zip" ] && echo "ERROR: Failed to download npm.zip. Aborting..." && cd "$_pwd" && return
	
		echo "Extracting npm.zip into node_modules/ ..."
		mkdir -p node_modules
		/usr/bin/unzip -q npm.zip -d node_modules/ 2>&1 >/dev/null
		[ ! -d "node_modules/npm-6.1.0" ] && echo "ERROR: Failed to extract npm.zip. Aborting..." && cd "$_pwd" && return
		mv node_modules/npm-6.1.0 node_modules/npm

		if isLinux ; then
			echo "Copying npm to current directory ..."
			cp node_modules/npm/bin/npm .
		else
			echo "Copying npm.cmd to current directory ..."
			cp node_modules/npm/bin/npm.cmd .
		fi
	
		# Run npm to install some stuff.
		#
		# Remember: NPM is the node package manager, which installs packages locally into a 
		#           project, specifically, into the "node_modules" folder.
		#
		# Note: We don't use the npm 'global' (-g) option here, because that will
		#       copy the exe etc (e.g. bin/http-server) somewhere like /usr/lib
		if isLinux ; then
			chmod +x npm node
			# Express (https://www.tutorialkart.com/nodejs/what-is-express-js/)
			#./npm --silent install express
			# csvtojson (https://www.npmjs.com/package/csvtojson)
			./npm --silent install csvtojson
			# http-server (https://www.js-tutorials.com/nodejs-tutorial/setup-node-http-server-example/)
			./npm --silent install http-server
		else
			chmod +x npm.cmd node.exe
			# Express (https://www.tutorialkart.com/nodejs/what-is-express-js/)
			#cmd /c .\\npm.cmd --silent install express
			# csvtojson (https://www.npmjs.com/package/csvtojson)
			cmd /c .\\npm.cmd --silent install csvtojson
			# http-server (https://www.js-tutorials.com/nodejs-tutorial/setup-node-http-server-example/)
			cmd /c .\\npm.cmd --silent install http-server
		fi
		printf "\nYou may now want to run some NodeJS demos:\nrun_nodejs_demos\n\n"
	fi

	cd "$_pwd"
	printf  "\nNode.js installation complete!"
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
