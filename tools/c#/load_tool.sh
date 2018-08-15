TOOLS_DIR=$*

# Description:
#   Demo C# web service client. 
#
# Build instructions:
#   1. Launch Windows SDK:
#      C:\Windows\System32\cmd.exe /E:ON /V:ON /T:0E /K "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd"
# 
#   2. Generate GlobalWeather.cs:
#      wsdl http://www.webservicex.net/globalweather.asmx?WSDL
#
#   3. Build GlobalWeather.dll:
#      csc /t:library GlobalWeather.cs
#
#   4. Build demo DemoWeather.exe:
#      csc /r:GlobalWeather.dll DemoWeather.cs
#
# Web service details:
#   http://www.webservicex.net/ws/WSDetails.aspx
#
# Usage demo:
#   C:\Programming\C#>DemoWeather.exe
#   Enter Country: France
#   <NewDataSet>
#   <Table>
#    <Country>France</Country>
#    <City>Le Touquet</City>
#    ...
#
function csharp_webservice_demo() {
    if [ "$1" = '-h' ]; then
        usage csharp_webservice_demo
        return
    fi
}
