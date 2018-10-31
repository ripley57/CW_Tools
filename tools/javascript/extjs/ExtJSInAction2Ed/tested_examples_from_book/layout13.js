/*
** The Border layout.
*/

Ext.create('Ext.Viewport', {
 layout : 'border',
 defaults : {
	frame : true,
	split : true
 },
 items : [
	{
		title : 'North Panel',
		region : 'north',
		height : 100,
		minHeight : 100,
		maxHeight : 150,
		collapsible : true
	},
	{
		title : 'South Panel',
		region : 'south',
		height : 75,
		split : false,
		margins : {
			top : 25
		}
	},
	{
		title : 'East Panel',
		region : 'east',
		width : 100,
		minWidth : 75,
		maxWidth : 150,
		collapsible : true
	},
	{
		title : 'West Panel',
		region : 'west',
		collapsible : true,
		collapseMode : 'mini',
		width : 100
	},
	{
		title : 'Center Panel',
		region : 'center'
	}
 ]
 });
 