/*
** File Upload Demo (for ESA-48432).
**
** To load this JavaScript demo, load file_upload_demo.html via the Jetty web server, e.g.:
** http://localhost:8080/list/file_upload_demo.html
**
** Note: This demo uses my DummyResponseServlet to return a JSON "success" response.
**
** See also similar JavaScript demo here:
** https://stackoverflow.com/questions/14110084/why-success-callback-is-not-called-in-extjs-form-submission
**
** JeremyC 31-10-2018
*/

var fpItems =[
	new Ext.form.FileUploadField({
		allowBlank: false,
		emptyText:  'Please choose a license package',
		fieldLabel: 'License Path',
		name:       'licensePath',
		regex:      new RegExp('.zip|.slf$'),
		width:      400,
	}),
];

var fp = new Ext.form.FormPanel({
	renderTo : Ext.getBody(),
	title : 'File Upload Demo',
	frame : true,
	items : fpItems,
	buttons : [
		{
			text : 'Submit',
			handler : function() {
				this.up('form').getForm().submit({
					url: '/ctx2/dummyresponse/',
					success: function (formPanel, action) {
						Ext.Msg.alert('Success');
					},
					failure: function (formPanel, action) {
						Ext.Msg.alert('Failure');
					}
				});
			}
		}
	]
});

Ext.create('Ext.Window', {
	height : 200,
	width : 500,
	border : false,
	layout : 'fit',
	items : fp
}).show();
