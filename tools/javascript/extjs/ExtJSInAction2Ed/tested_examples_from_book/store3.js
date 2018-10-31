/*
** JSON store example.
*/

var departmentStore = Ext.create('Ext.data.Store', {
 fields : [
	'name',
	'active',
	'dateActive',
	'dateInactive',
	'description',
	'director',
	'numEmployees',
	{
		name : 'id',
		type : 'int'
	}
 ],
 proxy : {
	type : 'ajax',
	url : 'data_store3.json',
	reader : {
		type : 'json',
		root : 'data',
		idProperty : 'id',
		successProperty : 'meta.success'
	}
 }
});
 
departmentStore.load({
	callback : function(records, operation, successful) {
		if (successful) {
			console.log('department name:',records[0].get('name'));
		}
		else {
			console.log('the server reported an error');
		}
	}
});
