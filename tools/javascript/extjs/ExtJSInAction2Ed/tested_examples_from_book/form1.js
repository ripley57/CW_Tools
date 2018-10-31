
Ext.QuickTips.init();

 var fpItems =[
 {
	fieldLabel : 'Alpha only',
	allowBlank : false,
	emptyText : 'This field is empty!',
	maskRe : /[a-z]/i ,
	msgTarget : 'side'
 },
 {
	fieldLabel : 'Simple 3 to 7 Chars',
	allowBlank : false,
	msgTarget : 'under',
	minLength : 3, 
	maxLength : 7
 },
 {
	fieldLabel : 'Special Chars Only',
	msgTarget : 'qtip',
	stripCharsRe : /[a-zA-Z0-9]/ig
 },
 {
	fieldLabel : 'Web Only with VType',
	vtype : 'url',
	msgTarget : 'side'
 },
 {
	fieldLabel : 'Password',
	allowBlank : false,
	inputType : 'password',
 },
 {
	fieldLabel : 'File',
	allowBlank : false,
	xtype : 'filefield'
 },
 { 
	xtype : 'textarea',
	fieldLabel : 'My TextArea',
	name : 'myTextArea',
	anchor : '100%',
	height : 100
 },
 {
	xtype : 'numberfield',
	fieldLabel : 'Numbers only',
	allowBlank : false,
	emptyText : 'This field is empty!',
	decimalPrecision : 3,
	minValue : 0.001,
	maxValue : 2
 },
 {
	 xtype : 'timefield',
	 fieldLabel : 'Please select time',
	 anchor : '100%',
	 minValue : '09:00',
	 maxValue : '18:00',
	 increment : 30,
	 format : 'H:i'
 } 
 ];
 
 var fp = Ext.create('Ext.form.Panel', {
 renderTo : Ext.getBody(),
 width : 400,
 height : 450,
 title : 'Exercising textfields',
 frame : true,
 bodyStyle : 'padding: 6px',
 labelWidth : 126,
 defaultType : 'textfield',
 defaults : {
	msgTarget : 'side',
	anchor : '-20'
 },
 items : fpItems
 });
 