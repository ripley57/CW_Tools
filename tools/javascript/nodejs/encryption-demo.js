// Description:
//		Simple Node.js encryption and decryption demo.
//		To run:
//			node.exe <this-file-name>

//https://npm.taobao.org/package/crypto-js
// NOTE: You will first Need to run: npm install crypto-js
var crypto = require('crypto-js');

// Encrypted text string example.	
var password = 'hello';
var s = 'this is a secret message!';
var encrypted = crypto.AES.encrypt(s, password);
var decrypted = crypto.AES.decrypt(encrypted.toString(), password);
console.log('s=' + s.toString())
console.log('encrypted=' + encrypted)
console.log('decrypted=' + decrypted.toString(crypto.enc.Utf8))

// Write the encrypted string to a file.
var fs = require('fs');
fs.writeFile("encrypted-content.txt", encrypted, function(err) {
	if(err) {
		console.log(err);
	}
	console.log("The file was saved!");
}); 
	
// Read the encrypted string the file, decrypt and display.
fs.readFile("encrypted-content.txt", {"encoding": "utf8"}, function(err, data) {
	if (err)
		console.log(err);
	else {
		var contents = data;
		var decrypted = crypto.AES.decrypt(contents.toString(), password);
		console.log('decrypted=' + decrypted.toString(crypto.enc.Utf8));
	}
});
