var myBtnHandler = function(btn) {
 Ext.MessageBox.alert('You Clicked', btn.text);
 },
 fileBtn = Ext.create('Ext.button.Button', {
 text : 'File',
 handler : myBtnHandler
 }),
 editBtn = Ext.create('Ext.button.Button', {
 text : 'Edit',
 handler : myBtnHandler
 }),
 tbFill = new Ext.toolbar.Fill(); 
 
 var myTopToolbar = Ext.create('Ext.toolbar.Toolbar', {
 items : [
 fileBtn,
 tbFill,
 editBtn
 ]
});

var myBottomToolbar = [
 {
 text : 'Save',
 handler : myBtnHandler
 },
 '-',
 {
 text : 'Cancel',
 handler : myBtnHandler
 },
 '->',
 '<b>Items open: 1</b>'
];

var myPanel = Ext.create('Ext.panel.Panel', {
 width : 200,
 height : 150,
 title : 'Ext Panels rock!',
 collapsible : true,
 renderTo : Ext.getBody(),
 tbar : myTopToolbar,
 bbar : myBottomToolbar,
 html : 'My first Toolbar Panel!'
});

