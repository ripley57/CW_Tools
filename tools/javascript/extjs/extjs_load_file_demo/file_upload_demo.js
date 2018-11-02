/*
** File Upload Demo (for ESA-48432).
**
** To load this JavaScript demo, load file_upload_demo.html via the Jetty web server, e.g.:
** http://localhost:8080/list/file_upload_demo.html
**
** This demo was created to try and reproduce the following issue whereby the web browser wraps an HTML "<PRE>" tag around a JSON 
** response from the web server handling the Ajax request:
**   https://www.sencha.com/forum/archive/index.php/t-17248.html
**   https://docs.sencha.com/ext/5.0.0/api/src/Connection.js.html
** See also the screenshot Capture-no-PRE-tag-with-extjs420.png which shows where to set a breakpoint in order to see the server's 
** JSON response. My testing indicates (using a Windows 10 ie11 vm where this issue has been seen when using a v3-based extjs version), 
** that this issue does not occur with extjs v4.2.0.
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
