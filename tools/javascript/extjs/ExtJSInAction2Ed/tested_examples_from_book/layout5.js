/*
** The Fit layout.
*/

var myWin = Ext.create("Ext.Window", {
 height : 200,
 width : 200,
 layout : 'fit',
 border : false,
 items : [
	{
		title : 'Panel1',
		html : 'I fit in my parent!',
	frame : true
	}
 ]
 });
 myWin.show();