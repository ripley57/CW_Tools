var myCallback = function(btn, text) {
	console.info('You pressed ' + btn);
	if (text) {
		console.info('You entered : ' + text)
	}
}
	
 Ext.Msg.show({
	title : 'Input required:',
	msg : 'Please tell us a little about yourself',
	width : 300,
	buttons : Ext.Msg.OKCANCEL,
	multiline : true,
	fn : myCallback,
	icon : Ext.MessageBox.INFO
 });
 
 Ext.Msg.show({
	title : 'Hold on there cowboy!',
	msg : 'Are you sure you want to reboot the internet?',
	width : 300,
	buttons : Ext.Msg.YESNOCANCEL,
	fn : myCallback,
	icon : Ext.MessageBox.ERROR
});

