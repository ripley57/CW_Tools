
var radio_nogroup = [
 {
	xtype : 'radio',
	fieldLabel : 'Which do you own',
	boxLabel : 'Cat',
	name : 'rb',
	inputValue : 'cat'
 },
 {
	xtype : 'radio',
	fieldLabel : ' ',
	labelSeparator : ' ',
	boxLabel : 'Dog',
	name : 'rb',
	inputValue : 'dog'
 },
 {
	xtype : 'radio',
	fieldLabel : ' ',
	labelSeparator : ' ',
	boxLabel : 'Fish',
	name : 'rb',
	inputValue : 'fish'
 },
 {
	xtype : 'radio',
	fieldLabel : ' ',
	labelSeparator : ' ',
	boxLabel : 'Bird',
	name : 'rb',
	inputValue : 'bird'
 }
 ];
 
 var radio_group = {
	xtype : 'radiogroup',
	fieldLabel : 'Which do you own',
	columns : 2,
	anchor : '100%',
	items : [
		{
			boxLabel : 'Cat',
			name : 'rb',
			inputValue : 'cat'
		}, 
		{
			boxLabel : 'Dog',
			name : 'rb',
			inputValue : 'dog'
		},
		{
			boxLabel : 'Fish',
			name : 'rb',
			inputValue : 'fish'
		},
		{
			boxLabel : 'Bird',
			name : 'rb',
			inputValue : 'bird'
		}
	]
 };
 

 var fp = Ext.create('Ext.form.Panel', {
 renderTo : Ext.getBody(),
 width : 250,
 height : 250,
 title : 'Exercising checkboxes',
 frame : true,
 bodyStyle : 'padding: 5px',
 labelWidth : 10,
 items : radio_nogroup
});
 
 
 