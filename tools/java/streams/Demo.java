/*
** Java 8 streams demo.
**
** From:
** http://www.baeldung.com/java-8-streams-introduction 
**
** NOTE:
** o Operations on streams don’t change the source.
**
** JeremyC 11-02-2018
*/

import java.nio.file.*;		// Path
import java.util.*;
import java.util.stream.*;

public class Demo
{
    public static void main(String[] args) throws Exception
    {
		try {
			new Demo().DEMO_forloop();					// Replace for loop with single statement.
			new Demo().DEMO_filter();					// Filter elements based on some condition.
			new Demo().DEMO_convert();					// Convert list of strings to Path instances.
			new Demo().DEMO_flatten();					// Flatten list.
			new Demo().DEMO_matches();					// Check for matching or non-matching elements.
			new Demo().DEMO_sum_list_of_values();		// Sum list of values.
			new Demo().DEMO_convert_stream_to_list();	// Convert stream to a list.
		}
		catch (Exception e)
		{
			System.err.println("ERROR: " + e);
		}
	}
	
	/*
	** BEFORE: isExist=true
	** AFTER: isEixst=true
	*/
	private void DEMO_forloop()
	{
		System.out.println("\nDEMO_forloop");
		List<String> list = Arrays.asList("sup1", "a", "sup3");
		boolean isExist = false;
		
		// old-stype for loop.
		isExist = false;
		for (String string : list) {
			if (string.contains("a")) {
				isExist = true;
				break;
			}
		}
		System.out.println("BEFORE: isExist=" + isExist);
	
		// new-style.
		isExist = false;
		isExist = list.stream().anyMatch(element -> element.contains("a"));
		System.out.println("AFTER: isEixst=" + isExist);
	}

	/*
	** BEFORE:
	** One
	** OneAndOnly
	** Derek
	** AFTER:
	** One
	** OneAndOnly
	*/
	private void DEMO_filter()
	{	
		System.out.println("\nDEMO_filter");
		ArrayList<String> list = new ArrayList<>();
		list.add("One");
		list.add("OneAndOnly");
		list.add("Derek");
		System.out.println("BEFORE: ");
		for (String s : list)
			System.out.println(s);
		Stream<String> stream1 = list.stream().filter(element -> element.contains("One"));
		System.out.println("AFTER: ");
		stream1.forEach(System.out::println);
	}
		
	/*
	** C:\My1.txt isAbsolute=true
	** My2.txt isAbsolute=false
	*/
	private void DEMO_convert()
	{
		System.out.println("\nDEMO_convert");
		List<String> uris = new ArrayList<>();
		uris.add("C:\\My1.txt");
		uris.add("My2.txt");
		Stream<Path> paths = uris.stream().map(uri -> Paths.get(uri));
		paths.forEach(this::handlePath);
		
	}
	private void handlePath(Path p) {
		String s = p.toString();
		boolean isAbsolute = p.isAbsolute();
		System.out.println("" + s + " isAbsolute=" + isAbsolute);
	}
	
			
	/*
	** BEFORE:
	** list1: [a, b, c]
	** list2: [d, e, f]
	** AFTER:
	** stream: [a, b, c, d, e, f]
	*/
	private void DEMO_flatten()
	{
		System.out.println("\nDEMO_flatten");
		List<String> list1 = Arrays.asList("a", "b", "c");
		List<String> list2 = Arrays.asList("d", "e", "f");
		List<Detail> details = new ArrayList<>();
		details.add(new Detail(list1));
		details.add(new Detail(list2));
		System.out.println("BEFORE:");
		System.out.println("list1: " + Arrays.toString(list1.toArray()));
		System.out.println("list2: " + Arrays.toString(list2.toArray()));
		Stream<String> stream = details.stream().flatMap(detail -> detail.getParts().stream());
		System.out.println("AFTER: ");	
		System.out.println("stream: " + Arrays.toString( stream.toArray()));
	}
	private class Detail {
		List<String> l = null;
		public Detail(List<String> l)	{ this.l = l; }
		public List<String> getParts() { return this.l;	}
	}
	
	/*
	** BEFORE: [sup1, a, sup3]
	** Searching for any element matching "sup1": true
	** Searching for all elements matching "fred": false
	** Searching for no elements matching "help": true
	*/
	private void DEMO_matches()
	{
		System.out.println("\nDEMO_matches");
		List<String> list = Arrays.asList("sup1", "a", "sup3");
		System.out.println("BEFORE: " + Arrays.toString(list.toArray()));
		boolean isMatch1 = list.stream().anyMatch(element -> element.contains("sup1"));
		System.out.println("Searching for any element matching \"sup1\": " + isMatch1);
		boolean isMatch2 = list.stream().allMatch(element -> element.contains("fred"));
		System.out.println("Searching for all elements matching \"fred\": " + isMatch2);
		boolean isMatch3 = list.stream().noneMatch(element -> element.contains("help"));
		System.out.println("Searching for no elements matching \"help\": " + isMatch3);
	}
	
	/*
	** BEFORE: List of integers to sum: [1, 5, 13]
	** AFTER: Sum=19
	*/
	private void DEMO_sum_list_of_values()
	{
		System.out.println("\nDEMO_sum_list_of_values");
		List<Integer> integers = Arrays.asList(1, 5, 13);
		System.out.println("BEFORE: List of integers to sum: " + Arrays.toString(integers.toArray()));
		Integer reduced = integers.stream().reduce(0, (a, b) -> a + b); // Starting value of 0.
		System.out.println("AFTER: Sum=" + reduced);
	}
	
	/*
	** BEFORE: [sup1, a, sup3]	
	** AFTER: [SUP1, A, SUP3]
	*/
    private void DEMO_convert_stream_to_list()
	{
		System.out.println("\nDEMO_convert_stream_to_list");
		List<String> list = Arrays.asList("sup1", "a", "sup3");
		System.out.println("BEFORE: " + Arrays.toString(list.toArray()));
		// Convert Stream<String> to List<String> (with strings converted to upper-case).
		List<String> resultList = list.stream().map(element -> element.toUpperCase()).collect(Collectors.toList());
		System.out.println("AFTER: " + Arrays.toString(resultList.toArray()));
	}
}
