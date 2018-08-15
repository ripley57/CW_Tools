/*
** Advanced grid example.
** Page 173 of ExtJSInAction 2nd Edition.
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

/*
var urlRoot = 'http://localhost:8080/ctx1/cgi-bin2/crud.exe?model=Employee&method=';
*/
var urlRoot = '/ctx1/cgi-bin2/crud.exe?model=Employee&method=';

var employeeStore = Ext.create('Ext.data.Store', {
 model : 'Employee',
 pageSize : 50,
 proxy : {
	type : 'jsonp',
	api : {
		create : urlRoot + 'CREATE',
		read : urlRoot + 'READ',
		update : urlRoot + 'UPDATE',
		destroy : urlRoot + 'DESTROY'
	},
	reader : {
		type : 'json',
		metaProperty : 'meta',
		root : 'data',
		idProperty : 'id',
		totalProperty : 'meta.total',
		successProperty : 'meta.success'
	},
	writer : {
		type : 'json',
		encode : true,
		writeAllFields : true,
		root : 'data',
		allowSingle : true,
		batch : false,
		writeRecords : function(request, data) {
			request.jsonData = data;
			return request;
		}
	}
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

var pagingToolbar = {
	xtype : 'pagingtoolbar',
	store : employeeStore,
	dock : 'bottom',
	displayInfo : true
};

var grid = Ext.create('Ext.grid.Panel', {
	xtype : 'grid',
	columns : columns,
	store : employeeStore,
	loadMask : true,
	selType : 'rowmodel',
	singleSelect : true,
	stripeRows : true,
	dockedItems : [
		pagingToolbar
	]
}); 

Ext.create('Ext.Window', {
	height : 350,
	width : 550,
	border : false,
	layout : 'fit',
	items : grid
}).show();

employeeStore.load(); 

