
var htmlEditor = Ext.create('Ext.form.HtmlEditor', {
 fieldLabel : "Enter in any text",
 anchor : '100% 100%',
 allowBlank : false,
 validate : function () {
 var val = this.getValue();
 return (this.allowBlank || val.length > 1);
 }
});
 
 var fp = Ext.create('Ext.form.Panel', {
 renderTo : Ext.getBody(),
 width : 600,
 height : 600,
 title : 'Exercising HTML Editor',
 frame : true,
 bodyStyle : 'padding: 6px',
 labelWidth : 126,
 items : htmlEditor
});