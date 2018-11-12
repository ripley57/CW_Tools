### Tutorials  
* https://docs.oracle.com/javase/tutorial/java/generics/index.html  
* https://docs.oracle.com/javase/tutorial/extra/generics/index.html

### Naming type parameters  
By convention, type parameter names are single, uppercase letters. The most commonly used type parameter names are:  
E - Element (used extensively by the Java Collections Framework)  
K - Key  
N - Number  
T - Type  
V - Value  
S,U,V etc. - 2nd, 3rd, 4th types  

### "type parameter" vs "type argument"  
The "T" in "Foo<T>" is a type parameter and the "String" in "Foo<String>" f is a type argument.

### Example of a generic class:  
  /**
  * Generic version of the Box class.
  * @param <T> the type of the value being boxed
  */
  public class Box<T> {
    // T stands for "Type"
    private T t;

    public void set(T t) { this.t = t; }
    public T get() { return t; }
  }  
To instantiate this class:  
  Box<Integer> integerBox = new Box<Integer>();
  
  
  
