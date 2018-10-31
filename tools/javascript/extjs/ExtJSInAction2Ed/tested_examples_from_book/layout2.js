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
		anchor : '100%, 25%',
		frame : true
	},
	{
		title : 'Panel2',
		anchor : '0, 50%',
		frame : true
	},
	{
		title : 'Panel3',
		anchor : '50%, 25%',
		frame : true
	}
 ]
 }));
 myWin.show();