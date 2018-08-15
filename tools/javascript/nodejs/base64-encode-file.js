	// Description:
	//		Encode / decode file in base64.
	//
	// Usage:
	//		node.exe base64-encode-file.js file1 file2 ...
	//
	// JeremyC 21-07-2018
	
	// Built-in Node.js modules.
	var path = require('path');
	var fs = require('fs');

	// Program input arguments.
	var program_name	= process.argv[0]; // value will be "node.exe"
	var script_name		= path.basename(process.argv[1]); // value will be "base64-encode-file.js"
	var command			= process.argv[2]; // value will be "encode" or "decode".
	var fileArgs 		= process.argv.slice(3); // Skip the previous input args.
		
	if (process.argv.length < 4) {
		console.log('');
		console.log('ERROR: bad input arguments!');
		console.log('');
		console.log('Usage:');
		console.log('   node.exe ' + script_name + ' encode|decode file1 file2 file3 ...');
		console.log('');
		console.log('Examples:');
		console.log('   node.exe ' + script_name + ' encode kafka160120.jpg');
		console.log('   node.exe ' + script_name + ' decode kafka160120.jpg.encoded');
		process.exit(-1);
	}
		
	// function to encode file data to base64 encoded string
	// From https://stackoverflow.com/questions/28834835/readfile-in-base64-nodejs
	function base64_encode(input_file,output_file) {
		var content = fs.readFileSync(input_file);
		var encoded = new Buffer(content).toString('base64');
		fs.writeFileSync(output_file,encoded.toString());
	}

	// function to create file from base64 encoded string
	function base64_decode(input_file,output_file) {
		var content = fs.readFileSync(input_file);
		fs.writeFileSync(output_file, new Buffer(content.toString(), 'base64'));
	}

	// base64 encode or decode each file passed on the command-line.
	fileArgs.forEach(function(val, index, array) {
		if (command == "encode") {
			var input_file = val;
			var output_file = input_file + ".base64_encoded";
			console.log('Encoding input file ' + input_file + ' to create output file ' + output_file + ' ...');
			base64_encode(input_file,output_file);
		}
		if (command == "decode") {
			var input_file = val;
			var output_file = input_file + ".base64_decoded";
			console.log('Decoding input file ' + input_file + ' to create output file ' + output_file + ' ...');
			base64_decode(input_file,output_file);
		}
	})

	