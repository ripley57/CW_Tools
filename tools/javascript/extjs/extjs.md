# ExtJS

**Note:** See also my ExtJS demos in CW_Tool/tools/jetty.  


## ExtJS In Action 2nd Ed
### Getting sample "6.10_submitting_and_loading_our_form.html" to display:
When trying to run the samples in the book ExtJS In Action 2nd Edition, I got the following error:  
`Ext is undefined `  
I suspect this is caused by missing ExtJS style sheet references. Here's one of the samples that was failing like this (6.10_submitting_and_loading_our_form.html):  
```html
<link rel="stylesheet" type="text/css" href="../../ext4/resources/css/ext-all.css"/> 
<script type="text/javascript" src="../../ext4/ext-all-debug.js"></script>
```
To get this sample to work, I copied over the entire ExtJS 4.2.0 extracted directory I've been using (see my "download_extjs4" CW_Tools bash function), and used the same stylesheet references that were working for me:  
```html
<link rel="stylesheet" type="text/css" href="ext-4.2.0/resources/css/ext-all.css" />
<!--<script type="text/javascript" src="ext-4.2.0/adapter/ext/ext-base-debug.js"></script>-->
<script type="text/javascript" 	src="ext-4.2.0/ext-all-debug.js"></script>
```  

### Getting sample "6.10_submitting_and_loading_our_form.html" to load "data.json" - Part 1  
First of all, we need to workaround an apparently known issue with IE and the Gecko embedded HTML editor component used in this ExtJS sample. This causes an "IndexSizeError" error when the sample HTML is loaded in IE11. See https://www.sencha.com/forum/showthread.php?291015-IndexSizeError-at-onFirstFocus()-function-of-htmleditor-inside-rowexpander-in-IE11. I got this when using ExtJS 4.2.0 (I haven't re-tested yet with a more recent version). To avoid this issue, I simply used Chrome instead.  

### Getting sample "6.10_submitting_and_loading_our_form.html" to load "data.json" - Part 2  
I am running the ExtJS samples by serving their HTML file using my **run_jetty** CW_Tools command. This uses Jetty **ResourceHandler.java** to serve the files from the directy where the **run_jetty** command is started. This enables GET requests to be fullfilled that originate from the sample JavaScript, which can be files that contain a simulated json response. However, when running sample "6.10_submitting_and_loading_our_form.html" and clicking the "load" button, the request is a "POST", which results in a 404 error. To workaround this, there are two options: 1) Change the ExtJS "load" button handler to use "GET" instead of "POST", or 2) Extend Jetty's **ResourceHandler.java** and redirect any POST request to the existing GET code. Here's the simple workaround; to update the ExtJS demo:
```html
    var loadHandler = function() {
        var formPanel = Ext.getCmp('myFormPanel');
//        formPanel.el.mask('Please wait', 'x-mask-loading');

        formPanel.getForm().load({
            url     : 'data.json',
            method : 'GET',
            success : function() {
                var formPanel = Ext.getCmp('myFormPanel');
                formPanel.el.unmask();
            }
        });
    };
```  

## ExtJS Downloads

### 4.2.0  
http://cdn.sencha.com/ext/commercial/ext-4.2.0-commercial.zip  
http://cdn.sencha.com/ext/gpl/ext-4.2.0-gpl.zip  


### 3.4.1.1  
http://cdn.sencha.com/ext/commercial/ext-3.4.1.1-commercial.zip  
http://cdn.sencha.com/ext/gpl/ext-3.4.1.1-gpl.zip  

