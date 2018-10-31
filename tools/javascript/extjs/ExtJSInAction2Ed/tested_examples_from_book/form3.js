/*
NOTE: Responsibility for only returning a page of results each time is that of the server.

The "pageSize" value we specify for the store, is passed to the server when we use the combobox pull-down. The size is the "limit=7" value shown below in a Fiddler capture:

GET http://localhost:8080/list/dataQuery.json?_dc=1532262965065&query=&page=1&start=0&limit=7&filter=%5B%7B%22property%22%3A%22fullName%22%7D%5D HTTP/1.1

The "pageSize" value we set in the combobox settings is only used to enable the page buttons. It does nothing more. As mentioned online, it should really be changed to a boolean value, because the numerical value is ignored. 

See also http://skirtlesden.com/articles/extjs-comboboxes-part-2

JeremyC 22-07-2018
*/

var remoteJsonStore = Ext.create(Ext.data.JsonStore, {
 storeId : 'people',
 pageSize : 7,	// This needs to be set here, because setting this value on the combobox below does nothing, apart from enabling the paging buttons.
 
 fields : [
	'fullName',
	'id'
 ],
 proxy : {
	type : 'ajax',
	url : 'dataQuery.json',
	reader : {
		type : 'json',
		root : 'value.records',
		totalProperty : 'value.totalCount',
		enablePaging : true
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
	pageSize : true	// This needs to be here in order to display the paging buttons.
}
];
 
 var fp = Ext.create('Ext.form.Panel', {
 renderTo : Ext.getBody(),
 width : 400,
 height : 400,
 title : 'Exercising remote combobox',
 frame : true,
 bodyStyle : 'padding: 6px',
 labelWidth : 126,
 items : fpItems
});
 