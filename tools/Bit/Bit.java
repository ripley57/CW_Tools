import java.util.*;

public class Bit
{
        public static void main(String[] args) throws Exception
        {
			if (args.length != 3) {
				System.out.println("java Bit clear|set flags flag");
				System.exit(0);
			}
			
			String clear_or_set 	 = args[0];
			int all_flags		 = Integer.parseInt(args[1]);
			int flag_to_clear_or_set = Integer.parseInt(args[2]);
			
			System.out.println("clear_or_set            = " + clear_or_set);
			System.out.println("all_flags               = " + all_flags);
			System.out.println("flag_to_clear_or_set    = " + flag_to_clear_or_set);
			
			if (clear_or_set.equals("clear")) {
				// Clear flag
				all_flags &= ~flag_to_clear_or_set;
			} else {
				// Set flag
				all_flags |= flag_to_clear_or_set;
			}
			System.out.println("after update: all_flags = " + all_flags);
        }
}
