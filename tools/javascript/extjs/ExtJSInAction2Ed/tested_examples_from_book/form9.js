
var checkboxes_nogroup = [
 {
	xtype : 'checkbox',
	fieldLabel : 'Which do you own',
	boxLabel : 'Cat',
	inputValue : 'cat'
 },
 {
	xtype : 'checkbox',
	fieldLabel : ' ',
	labelSeparator : ' ',
	boxLabel : 'Dog',
	inputValue : 'dog'
 },
 {
	xtype : 'checkbox',
	fieldLabel : ' ',
	labelSeparator : ' ',
	boxLabel : 'Fish',
	inputValue : 'fish'
 },
 {
	xtype : 'checkbox',
	fieldLabel : ' ',
	labelSeparator : ' ',
	boxLabel : 'Bird',
	inputValue : 'bird'
 }
 ];
 
 var checkboxes_group = {
	xtype : 'checkboxgroup',
	fieldLabel : 'Which do you own',
	columns : 2,
	anchor : '100%',
	items : [
		{
			boxLabel : 'Cat',
			inputValue : 'cat'
		}, 
		{
			boxLabel : 'Dog',
			inputValue : 'dog'
		},
		{
			boxLabel : 'Fish',
			inputValue : 'fish'
		},
		{
			boxLabel : 'Bird',
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
 items : checkboxes_group
});
 
 
 