/*
** XML store example.
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
		mapping : 'int'
	}
 ],
 proxy : {
	type : 'ajax',
	url : 'data_store4.xml',
	reader : {
		type : 'xml',
		record : 'node',
		idPath : 'id',
		successProperty : 'meta/success'
	}
 }
});
 
departmentStore.load({
	callback : function(records, operation, successful) {
		//console.log(operation);
		if (successful) {
			console.log("department:%o",records[0].get('name'));
		}
		else {
			console.log('the server reported an error');
		}
	}
});
