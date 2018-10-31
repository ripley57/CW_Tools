

var mySimpleStore = ({
 type : 'array',
 fields : ['name'],
 data : [
	['Jack Slocum'],
	['Abe Elias'],
	['Aaron Conran'],
	['Evan Trimboli']
 ]
 });



 var fpItems =[
 {
	xtype : 'combo',
	fieldLabel : 'Select a name',
	store : mySimpleStore,
	displayField : 'name',
	typeAhead : true,
	mode : 'local'
 }
 ];
 
 var fp = Ext.create('Ext.form.Panel', {
 renderTo : Ext.getBody(),
 width : 400,
 height : 400,
 title : 'Exercising combobox',
 frame : true,
 bodyStyle : 'padding: 6px',
 labelWidth : 126,
 items : fpItems
});
 