/*
** The Column layout.
*/

var myWin = Ext.create("Ext.Window", {
	height : 200,
	width : 400,
	autoScroll : true,
	id : 'myWin',
	title : 'A Window with a Column layout',
	layout : 'column',
	defaults : {
		frame : true
	},
	items : [
		{
			title : 'Col 1',
			id : 'col1',
			columnWidth : .3
		},
		{
			title : 'Col 2',
			html : "20% relative width",
			columnWidth : .2
		},
		{
			title : 'Col 3',
			html : "100px fixed width",
			width : 100
		},
		{
			title : 'Col 4',
			frame : true,
			html : "50% relative width",
			columnWidth : .5
		}
	]
 });
 myWin.show();
 
Ext.getCmp('col1').add({
 height : 250,
 title : 'New Panel',
 frame : true
 });