
var fpItems =[
 {
	xtype : 'htmleditor',
	fieldLabel : 'Enter in any text',
	anchor : '100% 100%'
 }
];
 
 var fp = Ext.create('Ext.form.Panel', {
 renderTo : Ext.getBody(),
 width : 600,
 height : 600,
 title : 'Exercising HTML Editor',
 frame : true,
 bodyStyle : 'padding: 6px',
 labelWidth : 126,
 items : fpItems
});