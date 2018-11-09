/*
** Simple demo of using an anonymous class, from:
** https://docs.oracle.com/javase/tutorial/java/javaOO/anonymousclasses.html
**
** Points of interest:
** o The class declaration body is allowed to contain method declarations, but statements are not allowed.
** o Because an anonymous class definition is an expression, it must be part of a statement. That's why the line ends with a semicolon.
** o An anonymous class cannot access local variables in its enclosing scope that are not declared as final or effectively final.
** 
** Note: If the interface contains only one method (as in this example), you can use a lambda expression instead of an anonymous class 
**       expression. A lambda expression is simply more consise than using an anonymous class (see separate lambda demos).
**
** 09-11-2018
*/

public class AnonymousClassDemo {
	
    interface HelloWorld {
        public void greetSomeone(String someone);
    }
  
    public void sayHello() {
		// Is NOT using an anonymous class.
        class EnglishGreeting implements HelloWorld {
            String name = null;

            public void greetSomeone(String someone) {
                name = someone;
                System.out.println("Hello " + name);
            }
        }
        HelloWorld englishGreeting = new EnglishGreeting();
        
		// IS using an anonymous class.
        HelloWorld frenchGreeting = new HelloWorld() {
            String name = null;
			
            public void greetSomeone(String someone) {
                name = someone;
                System.out.println("Salut " + name);
            }
        };
        
        englishGreeting.greetSomeone("Bert");
        frenchGreeting.greetSomeone("Fred");
    }

    public static void main(String... args) {
        AnonymousClassDemo myApp =
            new AnonymousClassDemo();
        myApp.sayHello();
    }            
}
