/*
** Data store using a local array. 
** Using shortcut syntax; avoids need to declare the proxy and the model.
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
	fields : ['personName', 'state']
});

store.loadData(arrayData);
console.log(store.first().data);


