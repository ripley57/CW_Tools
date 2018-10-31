/*
** First grid example.
*/

var arrayData = [
 ['Jay Garcia', 'MD'],
 ['Aaron Baker', 'VA'],
 ['Susan Smith', 'DC'],
 ['Mary Stein', 'DE'],
 ['Bryan Shanley', 'NJ'],
 ['Nyri Selgado', 'CA']
];

var store = Ext.create('Ext.data.ArrayStore', {
 data : arrayData,
 fields : ['fullName', 'state']
}); 

var grid = Ext.create('Ext.grid.Panel', {
 title : 'Our first grid',
 renderTo : Ext.getBody(),
 autoHeight : true,
 width : 250,
 store : store,
 selType : 'rowmodel',
 singleSelect : true,
 columns : [
	{
		header : 'Full Name',
		sortable : true,
		dataIndex : 'fullName'
	},
	{
		header : 'State',
		dataIndex : 'state'
	}
 ]
});
