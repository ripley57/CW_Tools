/*
** Simple Enum demo.
**
** JeremyC 16-07-2018
*/

public class Demo
{
	static enum OptionsEnum {
		OPTION_ONE("OptionOne", "This is option one"),
		OPTION_TWO("OptionTwo", "This is option two");

		private String m_oname;
		private String m_description;

		OptionsEnum(String oname, String description) {
			m_oname = oname;
			m_description = description;
		}

		public String getName() {	return m_oname;		}
		public String getDescription() {	return m_description;		}
	}
	
	public static void main(String[] args) throws Exception
    {
        decodeOption("OPTION_ONE");
		decodeOption("OPTION_TWO");
		
		// This one will error! The error should be: "java.lang.IllegalArgumentException: No enum constant Demo.OptionsEnum.OptionOne"
		decodeOption("OptionOne");
    }
	
	private static void decodeOption(String o)
	{
		OptionsEnum e = OptionsEnum.valueOf(o);
		switch (e) {
			case OPTION_ONE:
				System.out.println("You selected OPTION_ONE !");
				break;
			case OPTION_TWO:
				System.out.println("You selected OPTION_TWO !");
				break;
		}
	}
}