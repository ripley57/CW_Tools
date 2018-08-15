using System;	// For Console.
using System.Data;
using System.Xml;

class DemoWeather
{
	public static void Main(string[] args)
	{
		// Create instance of the GlobalWeather.dll.
		GlobalWeather Weather = new GlobalWeather();
		
		// Get input from user. 
		// NOTE: An input value of "France" does work (as of 23/10/2016).
		Console.Write("Enter Country: ");
		string Country = Console.ReadLine();
		
		string Data = Weather.GetCitiesByCountry(Country);
		Console.WriteLine(Data);
		
		//converting the string Respsonse to XML   
        //XmlTextReader xtr = new XmlTextReader(new System.IO.StringReader(Data));  
		//DataSet ds = new DataSet();  
		//ds.ReadXml(xtr); 
		//Console.Write(ds.GetXml());
	}
}