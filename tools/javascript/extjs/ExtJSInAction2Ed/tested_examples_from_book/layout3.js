/*
** The Anchor layout.
*/

var myWin = Ext.create("Ext.Window", ({
 height : 300,
 width : 300,
 layout : 'anchor',
 border : false,
 anchorSize : '400',
 items : [
	{
		title : 'Panel1',
		anchor : '-50, -150',
		frame : true
	},
	{
		title : 'Panel2',
		height : 150,
		anchor : '-10',
		frame : true
	},
 ]
 }));
 myWin.show();