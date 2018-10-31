/*
** Complex form example.
*/

 var fieldset1 = {
	xtype : 'fieldset',
	title : 'Name Information',
	flex : 1,
	border : true,
	defaultType : 'field',
	defaults : {
		anchor : '-10',
		allowBlank : false
	},
	items : [
	{
		fieldLabel : 'First',
		name : 'firstName'
	},
	{
		fieldLabel : 'Middle',
		name : 'middle'
	},
	{
		fieldLabel : 'Last',
		name : 'lastName'
	}
	]
 };
 
 var fieldset2 = Ext.apply({}, {
	flex : 1,
	title : 'Address Information',
	defaults : {
		layout : 'column',
		anchor : '100%'
	},
	items : [
	{
		fieldLabel : 'Address',
		name : 'address'
	},
	{
		fieldLabel : 'Street',
		name : 'street'
	},
	{
		xtype : 'container',
		items : [
		{
			xtype : 'fieldcontainer',
			columnWidth : .5,
			items : [
			{
				xtype : 'textfield',
				fieldLabel : 'State',
				name : 'state',
				labelWidth : 100,
				width : 150
			}
			]
		},
		{
			xtype : 'fieldcontainer',
			columnWidth : .5,
			items : [
			{
				xtype : 'textfield',
				fieldLabel : 'Zip',
				name : 'zip',
				labelWidth : 30,
				width : 162
			}
			]
		}
		]
	}
	]
}, fieldset1); 
 
var fieldsetContainer = {
	xtype : 'container',
	layout : 'hbox',
	layoutConfig : {
		align : 'stretch'
	},
	items : [
		fieldset1,
		fieldset2
	]
};

var tabs = [
{
	xtype : 'fieldcontainer',
	title : 'Phone Numbers',
	layout : 'form',
	defaults : {
		xtype : 'textfield',
		width : 200,
		labelStyle : 'padding: 3px 0px 0px 10px;',
	},
	items: [
	{
		fieldLabel : 'Home',
		name : 'home',
	},
	{
		fieldLabel : 'Business',
		name : 'business'
	},
	{
		fieldLabel : 'Mobile',
		name : 'mobile'
	},
	{
		fieldLabel : 'Fax',
		name : 'fax'
	}
	]
 },
 {
	xtype : 'htmleditor',
	title : 'Resume',
	name : 'resume'
 },
 {
	xtype : 'htmleditor',
	title : 'Bio',
	name : 'bio'
 }
];
 
var tabPanel = {
	xtype : 'tabpanel',
	activeTab : 0,
	deferredRender : false,
	layoutOnTabChange : true,
	border : true,
	flex : 1,
	plain : true,
	items : tabs
 }

  Ext.create("Ext.Window", {
	renderTo : Ext.getBody(),
	width : 650,
	title : 'Our complex form',
	frame : true,
	id : 'myFormPanel',
	layout : {
		type : 'vbox',
		align : 'stretch',
	},
	items : [
		fieldsetContainer,
		tabPanel
	]
 })
.show();