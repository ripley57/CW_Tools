var win = Ext.create('Ext.window.Window', {
	height : 75,
	width : 200,
	modal : true,
	title : 'This is one rigid window',
	html : 'Try to move or resize me. I dare you.',
	plain : true,
	border : false,
	resizable : false,
	draggable : false,
	closable : false,
	buttonAlign : 'center',
	buttons : [
		{
			text : 'I give up!',
			handler : function() {
				win.close();
			}
		}
	]
 })
win.show();