	XSL transformation including XSL "for" loop
	===========================================

	This script was created because I needed to repeat the following XML snippet many times:

	<EVCustomAttribute>
		<name>frdn</name>
		<value class="string">Hannah.Rodriguez@edp.lab</value>
		<operator>EQUALS</operator>
		<valueType>java.lang.String</valueType>
	</EVCustomAttribute>

	I needed to repeat this with different "<value>...</value>" values, and for different "<name>...</name>" values.
	
	The different "<value>...</value>" values are in the input.xml file. And the different "<name>...</name>" values are hard-coded in an XSL "for" loop.

	NOTE: The script output is an XML file, that needed to then be imported into the "CUSTOM_ATTR_XML" field of a MySQL table, which was done like this:
	
	mysql.exe -uroot -p esadb_lds_evidence_repo_a8e6sowft2 -e "update t_ev_mail_search_preview_params set CUSTOM_ATTR_XML = LOAD_FILE('d:/custom_attr_xml.xml') where id = 7599850140991535"

	
JeremyC 26-10-2018
