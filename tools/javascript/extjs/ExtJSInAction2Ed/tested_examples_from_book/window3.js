
var myCallback = function(btn, text) {
	console.info('You pressed ' + btn);
	if (text) {
		console.info('You entered : ' + text)
	}
}

//var msg = 'Your document was saved successfully';
//var title = 'Save status:'
//Ext.MessageBox.alert(title, msg);

var msg = 'Please enter your email address.';
var title = 'Input Required'
Ext.MessageBox.prompt(title, msg, myCallback);