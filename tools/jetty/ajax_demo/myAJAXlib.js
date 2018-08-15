/*
   My own AJAX library of JavaScript functions
*/

function createREQ() {
    try {
        req = new XMLHttpRequest();
    } catch(err1) {
        try {
            req = new ActiveXObject("Msxml2.XMLHTTP");
        } catch(err2) {
            try {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(err3) {
                req = false;
            }
        }
    }
    return req;
}

function requestGET(url, query, req, getxml) {
    myRand = parseInt(Math.random() * 99999999999999); /* Prevent GET browser cache issues */
    req.open("GET", url+'?'+escape(query)+'&rand='+myRand, true);

    if (getxml == 1) {
	// Force the response to be interpreted as XML.
	// I needed this, because I was getting null
	// for http.responseXML (testing on Chrome with
	// Jetty web server).  
	req.overrideMimeType('text/xml');
    }

    req.send(null);
}

function requestPOST(url, query, req, getxml) {
    req.open("POST", url, true);
    req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    if (getxml == 1) {
	// Force the response to be interpreted as XML.
	// I needed this, because I was getting null
	// for http.responseXML (testing on Chrome with
	// Jetty web server).  
	req.overrideMimeType('text/xml');
    }

    req.send(escape(query));
}

function doCallback(callback, item) {
    eval(callback + '(item)');
}

function doAjax(url, query, callback, reqtype, getxml) {
    // Create the XMLHttpRequest object instance
    var myreq = createREQ();

    myreq.onreadystatechange = function() {
        if (myreq.readyState == 4) {
            if (myreq.status == 200) {
                var item = myreq.responseText;
                if (getxml == 1) {
                    item = myreq.responseXML;
                }
                doCallback(callback, item);
            }
        }
    }

    if (reqtype == 'post') {
        requestPOST(url, query, myreq, getxml);
    } else {
    	requestGET(url, query, myreq, getxml);
    }
}
