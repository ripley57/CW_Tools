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
	// Adding a panel inside a container enables us to dynamically change the content.
	// This is not otherwise possible if a panel is added directly as a Border layout region (see previous demo js file).
	{
		xtype : 'container',
		region : 'center',
		layout : 'fit',
		id : 'centerRegion',
		items : {
			title : 'Center Region',
			id : 'centerPanel',
			html : 'I am disposable',
			frame : true
		}
	}
 ]
 });
 
 // Now we can dynamically add some content to the panel in the center region.
var centerPanel = Ext.getCmp('centerPanel');
var centerRegion = Ext.getCmp('centerRegion');
centerRegion.remove(centerPanel, true);
centerRegion.add({
	 xtype : 'form',
	frame : true,
	bodyStyle : 'padding: 5px',
	defaultType : 'field',
	title : 'Please enter some information',
	defaults : {
		anchor : '-10'
	},
	items : [
		{
			fieldLabel : 'First Name'
		},
		{
			fieldLabel : 'Last Name'
		},
		{
			xtype : 'textarea',
			fieldLabel : 'Bio'
		}
	]
 });

 
 