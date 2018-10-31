
var fpItems =[
 {
 xtype : 'datefield',
 fieldLabel : 'Please select a date',
 anchor : '100%'
 }
];
 
 var fp = Ext.create('Ext.form.Panel', {
 renderTo : Ext.getBody(),
 width : 600,
 height : 600,
 title : 'Exercising Date widget',
 frame : true,
 bodyStyle : 'padding: 5px',
 labelWidth : 126,
 items : fpItems
});