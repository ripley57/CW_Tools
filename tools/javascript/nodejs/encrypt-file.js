	// Description:
	//		Node.js AES encryption and decryption demo.
	//
	//		The purpose of this demo is to use the same JavaScript
	//		AES encryption library that I plan to use for displaying
	//		decrypted images in my GitHub pages website. Here I want
	//		to create a tool that I can use to create the encrypted 
	//		image files that will be used on that website.		
	//
	// Usage:
	//		node.exe encrypt-file.js password encrypt|decrypt file1 file2 ...
	//
	// JeremyC 21-07-2018
	
	// Built-in Node.js modules.
	var path = require('path');
	var fs = require('fs');
	var crypto = require('crypto');
	var algorithm = 'aes-256-ctr';

	// Program input arguments.
	var program_name	= process.argv[0]; // value will be "node.exe"
	var script_name		= path.basename(process.argv[1]); // value will be "encrypt-file.js"
	var password 		= process.argv[2]; // value should be your secret password key.
	var command			= process.argv[3]; // value should be "encrypt" or "decrypt".
	var fileArgs 		= process.argv.slice(4); // Skip the previous input args.
		
	if (process.argv.length < 5) {
		console.log('');
		console.log('ERROR: bad input arguments!');
		console.log('');
		console.log('Usage:');
		console.log('   node.exe ' + script_name + ' password encrypt|decrypt file1 file2 file3 ...');
		console.log('');
		console.log('Examples:');
		console.log('   node.exe ' + script_name + ' "hello" encrypt kafka160120.jpg');
		console.log('   node.exe ' + script_name + ' "hello" decrypt kafka160120.jpg.decrypted');
		process.exit(-1);
	}
		
	// Use Node.js pipe streams to encrypt or decrypt file contents. 
	// Note: pipe streams are asynchronous, which means calling function
	// decryptFile() immediately after calling encryptFile() is likely to
	// not decrypt successfully - for example, it left me with a 0-byte file.
	// From: https://github.com/chris-rock/node-crypto-examples/blob/master/crypto-stream.js
	function encryptFile(input_file,output_file,secret_key) {
		var r = fs.createReadStream(input_file);
		var encrypt = crypto.createCipher(algorithm,secret_key);
		var w = fs.createWriteStream(output_file);
		r.pipe(encrypt).pipe(w);
	}
	function decryptFile(input_file,output_file,secret_key) {
		var r = fs.createReadStream(input_file)
		var decrypt = crypto.createDecipher(algorithm,secret_key);
		var w = fs.createWriteStream(output_file);
		r.pipe(decrypt).pipe(w);
	}

	// Encrypt or decrypt each file passed on the command-line.
	fileArgs.forEach(function(val, index, array) {
		if (command == "encrypt") {
			var input_file = val;
			var output_file = input_file + ".encrypted";
			console.log('Encrypting input file ' + input_file + ' to create output file ' + output_file + ' ...');
			encryptFile(input_file,output_file,password);
		}
		if (command == "decrypt") {
			var input_file = val;
			var output_file = input_file + ".decrypted";
			console.log('Decrypting input file ' + input_file + ' to create output file ' + output_file + ' ...');
			decryptFile(input_file,output_file,password);
		}
	})

	