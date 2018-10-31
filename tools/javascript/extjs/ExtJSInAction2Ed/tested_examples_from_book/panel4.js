
var buttons = [
 { text : 'Btn 1' },
 { text : 'Btn 2' },
 { text : 'Btn 3' }
];

var topDockedToolbar = {
 xtype : 'toolbar',
 dock : 'top',
 items : buttons
};

var bottomDockedToolbar = {
 xtype : 'toolbar',
 dock : 'bottom',
 items : buttons
};

var leftDockedToolbar = {
 xtype : 'toolbar',
 vertical : true,
 dock : 'left',
 items : buttons
};

var rightDockedToolbar = {
 xtype : 'toolbar',
 vertical : true,
 dock : 'right',
 items : buttons
};

var myPanel = Ext.create('Ext.panel.Panel', {
 width : 350,
 height : 250,
 title : 'Ext Panels rock!',
 renderTo : Ext.getBody(),
 html : 'Content body',
 buttons : {
	weight : -1,
	items : buttons
 },
 dockedItems : [
	topDockedToolbar,
	bottomDockedToolbar,
	leftDockedToolbar,
	rightDockedToolbar
 ]
}); 

 var myWin = Ext.create('Ext.window.Window',{
 id : 'myWin',
 items : [
 myPanel
 ]
 });

Ext.onReady(function() {
 myWin.show();
});


