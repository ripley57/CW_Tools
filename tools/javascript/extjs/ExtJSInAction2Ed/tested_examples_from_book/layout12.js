/*
** The Table layout.
*/

var myWin = Ext.create("Ext.Window", {
 height : 300,
 width : 300,
 border : false,
 autoScroll : true,
 title : 'A Window with a Table layout',
 layout : {
	type : 'table',
	columns : 3
 },
 defaults : {
	height : 50,
	width : 50
 },
 items : [
	{
		html : '1',
		colspan : 3,
		width : 150
	},
	{
		html : '2',
		rowspan : 2,
		height : 100
	},
	{
		html : '3'
	},
	{
		html : '4',
		rowspan : 2,
		height : 100
	},
	{
		html : '5'
	},
	{
		html : '6'
	},
	{
		html : '7'
	},
	{
		html : '8'
	},
	{
		html : '9',
		colspan : 3,
		width : 150
	}
 ]
 });
 myWin.show();
 