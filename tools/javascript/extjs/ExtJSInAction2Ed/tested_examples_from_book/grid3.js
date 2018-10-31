/*
** Advanced buffered grid example.
*/

Ext.define('Employee', {
 extend : 'Ext.data.Model',
 idProperty : 'id',
 fields : [
	{name : 'id', type : 'int'},
	{name : 'departmentId', type : 'int' },
	{name : 'dateHired', type : 'date', format : 'Y-m-d'},
	{name : 'dateFired', type : 'date', format : 'Y-m-d'},
	{name : 'dob', type : 'date', format : 'Y-m-d'},
	'firstName',
	'lastName',
	'title',
	'street',
	'city',
	'state',
	'zip'
 ]
});

var url = '/ctx1/cgi-bin2/crud.exe?model=Employee&method=READ';
var bufferedEmployeeStore = Ext.create('Ext.data.Store', {
 model		: 'Employee',
 pageSize	: 50,
 buffered	: true,
 remoteSort : true,
 sorters : {
	property	: 'lastName',
	direction	: 'ASC'
 },
 proxy : {
	type 	: 'jsonp',
	url		: url,
	reader : {
		type		 	: 'json',
		root 			: 'data',
		idProperty 		: 'id',
		successProperty : 'meta.success',
		totalProperty 	: 'meta.total'
	},
 }
});

 var columns = [
 {
	xtype : 'templatecolumn',
	header : 'ID',
	dataIndex : 'id',
	sortable : true,
	width : 50,
	resizable : false,
	hidden : true,
	tpl : '<span style="color: #0000FF;">{id}</span>'
 }, 
 {
	header : 'Last Name',
	dataIndex : 'lastName',
	sortable : true,
	hideable : false, 
	width : 100
 },
 {
	header : 'First Name',
	dataIndex : 'firstName',
	sortable : true,
	hideable : false,
	width : 100
 }, 
 {
	header : 'Address',
	dataIndex : 'street',
	sortable : false,
	flex : 1,
	tpl : '{street}<br />{city} {state}, {zip}'
 }
];

var grid = Ext.create('Ext.grid.Panel', {
	xtype : 'grid',
	columns : columns,
	store : bufferedEmployeeStore,
	loadMask : true,
	verticalScroller : {
		trailingBufferZone : 10,
		leadingBufferZone : 10
	}
}); 

Ext.create('Ext.Window', {
	height : 350,
	width : 550,
	border : false,
	layout : 'fit',
	items : grid
}).show();

bufferedEmployeeStore.load(); 

 