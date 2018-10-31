/*
** The HBox and VBox layouts.
*/

Ext.create("Ext.Window", {
 layout : 'hbox',
 height : 300,
 width : 300,
 title : 'A Container with an HBox layout',
 
 // NOTE: This works in ExtJS4. 
 // See https://www.sencha.com/forum/showthread.php?124877-CLOSED-hbox-layout-layoutConfig-parameters-pack-and-align-not-working
 layout : {
	type : 'hbox',
	pack : 'end',
	align : 'stretch',
 },
 
 defaults : {
	frame : true,
	width : 75,
	padding : 0,
 },
 items : [
	{
		title : 'Panel 1',
		height : 100
	},
	{
		title : 'Panel 2',
		height : 75,
		width : 100
	},
	{
		title : 'Panel 3',
		height : 200
	}
 ]
 }).show();