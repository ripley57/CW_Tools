/*
** Data store using a local array.
*/

var arrayData = [
 ['Jay Garcia', 'MD'],
 ['Aaron Baker', 'VA'],
 ['Susan Smith', 'DC'],
 ['Mary Stein', 'DE'],
 ['Bryan Shanley', 'NJ'],
 ['Nyri Selgado', 'CA']
];

Ext.define('User', {
 extend : 'Ext.data.Model',
 fields : [
	{
		name : 'name',
		mapping : 1
	},
	{
		name : 'state',
		mapping : 2
	}
 ]
});

store = Ext.create('Ext.data.Store', {
 model : 'User',
 proxy : {
	type : 'memory',
	reader : {
		model : 'User',
		type : 'array'
	}
 }
});

store.loadData(arrayData);
console.log(store.first().data);


