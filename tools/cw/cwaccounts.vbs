' Description:
'	List CW service user accounts. 

class VBSServiceHelper
    
	private objWMIService
	private objNet
	
    private sub Class_initialize()
		If IsObject(objWMIService) = False Then
			Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
		End If
		If IsObject(objNet) = False Then
			Set objNet = CreateObject("WScript.Network") 
		End If
    end sub
    
    private sub Class_terminate()
		If IsObject(objWMIService) = True Then
			Set objWMIService = Nothing
		End If
		If IsObject(objNet) = True Then
			Set objNet = Nothing
		End If
    end sub
	
	private function tidyusername(strusername)
		Dim s, re
		Set re = New RegExp
		re.Pattern = "^\.\\"
		s = re.replace(strusername, "")
		tidyusername = s
	end function
    
	public function getserviceusername(strservicename)
		Dim objService, errNumber
		getserviceusername = ""
		On Error Resume Next	'Enable error handling.
		Set objService = objWMIService.Get("Win32_Service.Name='" & strservicename & "'")
		If Err.Number = 0 Then
			getserviceusername = tidyusername(objService.StartName)
		Else
			errNumber = Hex(Err.Number)
			On Error goto 0	'Disable error handling.
			Err.Raise 60001, "getserviceusername()", "ERROR: Could not find service with name: " & strservicename & " (" & errNumber & ")"
		End If
		On Error goto 0	'Disable error handling.
	end function
	
	private function gethostname()
		gethostname = objNet.ComputerName
	end function
	
	private function getdomainname()
		getdomainname = objNet.UserDomain
	end function
	
	''Given a username, return username and domainname (if included in username).
	private function parseusernamedomainname(strusername)
		Dim re, matches, m, arrusernamedomainname
		arrusernamedomainname = Array(strusername,"")	'Initially assume no domain included.
		Set re = New RegExp
		re.pattern = "^((.*)\\)?(.*)$"
		Set matches = re.Execute(strusername)
		For Each m In matches 
			arrusernamedomainname(0) = m.submatches(2)
			arrusernamedomainname(1) = m.submatches(1)
		Next
		parseusernamedomainname = arrusernamedomainname
	end function
	
	''Given a username, return the SID.
	public function convertusernametosid(strusername)
		Dim objAccount, errNumber, arrusernamedomainname, username, domainname
		convertusernametosid = ""
		
		arrusernamedomainname = parseusernamedomainname(strusername)	'Username may include domain name.
		username = arrusernamedomainname(0)
		domainname = arrusernamedomainname(1)
		If Len(domainame) = 0 Then	'No domain included in username, determine default domain. 
			domainname = getdomainname
		End If
		
		On Error Resume Next	'Enable error handling.
		Set objAccount = objWMIService.Get ("Win32_UserAccount.Name='" & username & "',Domain='" & domainname & "'")
		If Err.Number <> 0 Then 
			'Try using hostname.
			Err.Clear
			Set objAccount = objWMIService.Get ("Win32_UserAccount.Name='" & username & "',Domain='" & gethostname & "'")
		End If
		If Err.Number = 0 Then
			convertusernametosid = objAccount.SID
		Else
			errNumber = Hex(Err.Number)
			On Error goto 0	'Disable error handling.
			Err.Raise 60002, "convertusernametosid()", "ERROR: Could not determine SID for username: " & strusername & " (" & errNumber & ")"
		End If
		On Error Resume Next	'Enable error handling.
		Set objAccount = Nothing
	end function
	
end class

Function Rpad(as_string, ai_length) 
   Rpad = Left(as_string + Space(ai_length), ai_length) 
End Function

Dim services, arrCWServices, dictuseraccounts, username, i, k

Set services = new VBSServiceHelper
arrCWServices = Array (	_
					"EsaApplicationService", _
					"EsaPstCrawlerService", _
					"EsaPstRetrieverService", _
					"EsaEvCrawlerService", _
					"EsaEvRetrieverService", _
					"EsaExchangeCrawlerService", _
					"EsaExchangeRetrieverService", _
					"IGCBravaLicenseService", _
					"IGCJobProcessorService", _
					"DocumentConverterService", _
					"EsaNsfCrawlerService", _
					"EsaNsfRetrieverService", _
					"NxGridAgent", _
					"NxGridBase", _
					"NxGridGateway", _
					"EsaRissCrawlerService", _
					"EsaRissRetrieverService"	)

Set dictuseraccounts = CreateObject("scripting.dictionary")

'Display service usernames.
WScript.Echo VbCrLf & "CW user accounts:" & VbCrLf
For i = LBound(arrCWServices) To UBound(arrCWServices)
	username = services.getserviceusername(arrCWServices(i))
	WScript.Echo Rpad(arrCWServices(i),40) & username
	with dictuseraccounts
		if not .exists(username) then
			.add username, username
		end if
	end with
Next

'Display SIDs.
WScript.Echo VbCrLf & VbCrLf & "SIDs:" & VbCrLf
k = dictuseraccounts.Keys
For i = 0 To dictuseraccounts.Count - 1
    username = k(i)
	'WScript.Echo "username: " & username
	WScript.Echo Rpad(username,40) & services.convertusernametosid(username)
Next