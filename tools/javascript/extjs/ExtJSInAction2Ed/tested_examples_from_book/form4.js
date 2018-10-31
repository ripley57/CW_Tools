/*
** Demonstrates how you can display pretty much anything in a combobox.
*/

var remoteJsonStore = Ext.create(Ext.data.JsonStore, {
 storeId : 'people',
 fields : [
	'fullName',
	'id',
	'city',
	'state',
	'zip'
 ],
 proxy : {
	type : 'ajax',
	url : 'dataQuery2.json',
	reader : {
		type : 'json',
		root : 'records',
	}
 }
});

 var fpItems =[
 {
	xtype : 'combo',
	queryMode : 'remote',
	fieldLabel : 'Search by name',
	width : 320,
	forceSelection : true,
	displayField : 'fullName',
	valueField : 'id',	// for submission
	minChars : 1,
	triggerAction : 'all',
	store : remoteJsonStore,
	listConfig : {
		// Custom rendering template for each item.
		getInnerTpl : function() {
			return 	'<span><b>{fullName}</b></span><div class="combo-full-address">'+'{city} {state} {zip}</div><div class="combo-full-address">{id}</div>'; 
		}
	}
 }
];
 
 var fp = Ext.create('Ext.form.Panel', {
 renderTo : Ext.getBody(),
 width : 400,
 height : 400,
 title : 'Exercising remote combobox again',
 frame : true,
 bodyStyle : 'padding: 6px',
 labelWidth : 126,
 items : fpItems
});
 