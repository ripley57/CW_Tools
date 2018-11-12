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

### Example of a generic class with a single type parameter:  
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
  
### Example of a generic class with multiple type parameters:  
  public interface Pair<K, V> {
    public K getKey();
    public V getValue();
  }

  public class OrderedPair<K, V> implements Pair<K, V> {
    private K key;
    private V value;
  
    public OrderedPair(K key, V value) {
      this.key = key;
      this.value = value;
    }
  
    public K getKey()	{ return key; }
    public V getValue() { return value; }
  }
To instaice thie class:
  Pair<String, Integer> p1 = new OrderedPair<String, Integer>("Even", 8);  
  
### Generic Methods:  
Generic methods are methods that introduce their own type parameters:
  public class Util {
    public static <K, V> boolean compare(Pair<K, V> p1, Pair<K, V> p2) {
      return p1.getKey().equals(p2.getKey()) && p1.getValue().equals(p2.getValue());
    }
  }
Type "inference" means that this...   
  Pair<Integer, String> p1 = new Pair<>(1, "apple");
  Pair<Integer, String> p2 = new Pair<>(2, "pear");
  boolean same = Util.<Integer, String>compare(p1, p2);
...can be simplified to this:
  Pair<Integer, String> p1 = new Pair<>(1, "apple");
  Pair<Integer, String> p2 = new Pair<>(2, "pear");
  boolean same = Util.compare(p1, p2);
  
### Using "the diamand" to take advantage of type inference:  
This...
  Map<String, List<String>> myMap = new HashMap<String, List<String>>();
...can be replaced with this:
  Map<String, List<String>> myMap = new HashMap<>();  
  
### The question mark (?), called the wildcard, represents an unknown type:  
Say you want a method that works on List<Integer>, List<Double>, and List<Number>. You can achieve this by using an upper bounded wildcard:
  public void process(List<? extends Number> list)  { /* ... */ }
Note: in this context, "extends" means either "extends" (as in classes) or "implements" (as in interfaces).
