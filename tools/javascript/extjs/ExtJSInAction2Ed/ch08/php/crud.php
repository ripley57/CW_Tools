<?php

mysql_connect("localhost", "root", "teneo") or die ("could not connect:".mysql_error());
mysql_select_db("extjsinaction") or die ("extjsinaction database not found:".mysql_error());

require_once("employee.php");
require_once("state.php");

class Meta {
  public $success = false;
  public $msg = "";
};

class Response {
  public $data;
  public $meta;
};

$param = array();
$query_string = getenv('QUERY_STRING');
if (isset($query_string)) {
	// JeremyC
	// We are running this PHP script as a standalone exe, built using 
	// ExeOutput (https://www.exeoutput.com/download). Because this exe
	// is being called from Jetty as a cgi-bin program, and not from a 
	// regular PHP web server, the array $_REQUEST will not be populated
	// for us. Instead, we need to parse the "QUERY_STRING" environment
	// variable that is passed from Jetty (see CGI.java).  
	
	// From http://php.net/manual/en/function.urldecode.php
	foreach (explode('&', $query_string) as $chunk) {
		$param_pair = explode("=", $chunk);
		if ($param_pair) {
			$param[urldecode($param_pair[0])] = urldecode($param_pair[1]);
		}
	}
}
else { 
	$param["model"]     = $_REQUEST['model'];
	$param["id"]        = $_REQUEST['id'];
	$param["detail"]    = $_REQUEST['detail'];
	$param["parent"]    = $_REQUEST['parent'];
	$param["callback"]  = $_REQUEST['callback'];
	$param["start"]     = $_REQUEST['start'];
	$param["limit"]     = $_REQUEST['limit'];
	$param["sort"]      = $_REQUEST['sort'];
	
	$param["method"]	= $_REQUEST['method'];
	$param["JSON"]		= $_REQUEST["JSON"];
}

if (!isset($param["model"])) { $param["model"] = "Employee"; }
if (!isset($param["detail"])) { $param["detail"] = false; }

$method = $param['method'];
if (!isset($method)) { $method = "READ"; }

$datain_json = $param["JSON"];
if (isset($datain_json)) {
	$datain = json_decode($datain_json);
}
	
$data = array();
$msg = "";
$model = $param["model"];

//perform CRUD operations
try{
    $response = new Response();
    $response->meta = new Meta();
    switch( $method ) {
        case 'CREATE':
            $raw = '';
            $httpContent = fopen('php://input', 'r');
            while ($kb = fread($httpContent, 1024)) {
                $raw .= $kb;
            }
            fclose($httpContent);
            $datain = json_decode($raw);
            $response->data=$model::create($datain[0]);
            break;
        case 'READ':
            if (isset($param['limit'])){
                $response->meta->total = $model::totalcount($param);
            }
            $response->data = $model::read($param, $sort);
            break;
        case 'UPDATE':
            $raw = '';
            $httpContent = fopen('php://input', 'r');
            while ($kb = fread($httpContent, 1024)) {
                $raw .= $kb;
            }
            fclose($httpContent);
            $datain = json_decode($raw);
            $model::update($datain[0]);
            break;
        case 'DESTROY':
            $raw = '';
            $httpContent = fopen('php://input', 'r');
            while ($kb = fread($httpContent, 1024)) {
                $raw .= $kb;
            }
            fclose($httpContent);
            $datain = json_decode($raw);
            $response->data=$model::destroy($datain[0]);
        break;
    }
    $response->meta->success = "true";
    $response->meta->msg = "";
}catch (Exception $e) {
  $response->data = array();
  $response->meta->success = false;
  $response->meta->msg = "error";
}

$dataout = json_encode($response);

if (isset($param["callback"])) {
	// This request has come from ExtJS, because they've given us 
	// the JSONP callback, that we need to wrap around our response. 
	$dataout_with_callback = $param["callback"].'('.$dataout.')';
	print "Content-Type: application/json\n";
	print "Content-Length: " . strlen($dataout_with_callback) . "\n";
	print "\n";
    print $dataout_with_callback;
} else {
	// For testing on command-line, where we won't get the JSONP
	// callback querystring as added to the request by ExtJS.
	print "Content-Type: application/json\n";
	print "Content-Length: " . strlen($dataout) . "\n";
	print "\n";
    print $dataout;
}
?>
