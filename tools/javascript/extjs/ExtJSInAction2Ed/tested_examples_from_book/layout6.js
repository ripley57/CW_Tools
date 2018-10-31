/*
** The Accordian layout.
*/

var myWin = Ext.create("Ext.Window", {
 height : 200,
 width : 300,
 border : false,
 title : 'A Window with an Accordion layout',
 layout : 'accordion',
 layoutConfig : {
	animate : true
 },
 items : [
	{
		xtype : 'form',
		title : 'General info',
		bodyStyle : 'padding: 5px',
		defaultType : 'field',
		fieldDefaults : {
			labelWidth: 50
		},
		labelWidth : 50,
		items : [
			{
				fieldLabel : 'Name',
				anchor : '-10'
			},
			{
				xtype : 'field',
				fieldLabel : 'Age',
				size : 3
			},
			{
				xtype : 'combo',
				fieldLabel : 'Location',
				anchor : '-10',
				store : [ 'Here', 'There', 'Anywhere' ]
			}
		]
	},
	{
		xtype : 'panel',
		title : 'Bio',
		layout : 'fit',
		items : {
			xtype : 'textarea',
			value : 'Tell us about yourself'
		}
	},
	{
		title : 'Instructions',
		html : 'Please enter information.',
		tools : [
			{id : 'gear'}, {id:'help'}
		]
	}
 ]
 });
 myWin.show();
 