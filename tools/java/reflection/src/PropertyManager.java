package reflectiondemo;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

/**
 * PropertyManager 
 *
 * Use reflection on the passed class type to invoke the "set...()" methods
 * of the passed object, in order to intialise the member variables of the
 * object with values from a passed Properties object.
 *
 * Note: The invoked "set...()" and "get...()" methods are expected to exist. 
 *
 * 09-11-2018
 */
public class PropertyManager<T> {
	
	private static final String GET_PREFIX = "get";
	private static final String SET_PREFIX = "set";
    
	private Class<T> m_propClass;
    private volatile Map<String,Method> m_getMap = null;
    private volatile Map<String,Method> m_setMap = null;
	
	public static <T> PropertyManager<T> forClass(Class<T> propClass)
    {
        return new PropertyManager<T>(propClass);
    }
	
	private PropertyManager(Class<T> propClass) {
        m_propClass = propClass;
    }
	
	private Map<String,Method> getGetters() {
        if (m_getMap == null) {
            m_getMap = initGetMap();
        }
        return m_getMap;
    }
	
	private Map<String,Method> getSetters() {
        if (m_setMap == null) {
			m_setMap = initSetMap();
        }
        return m_setMap;
    }
	
	/*
	* Initialise Map of each property name and its corresponding "get...()" method.
	* Note: We only consider "get...()" methods with no input arguments.
	*/
	private Map<String,Method> initGetMap() {
        Map<String,Method> getMap = new HashMap<String,Method>();
        Method[] methods = m_propClass.getMethods();
		for (Method method : methods) {
			String methodName = method.getName();
			if (methodName.startsWith(GET_PREFIX) && methodName.length() > GET_PREFIX.length()) {
				Class<?>[] paramTypes = method.getParameterTypes();
				if (paramTypes.length != 0) {
					// We will ignore get methods that have input parameters, 
					// as these are obviously not proper getter methods.
					continue;	
				}
				String propertyName = methodName.substring(GET_PREFIX.length());
				// debug
				//System.err.println(String.format("initGetters() Adding getter for property: %s", propertyName));
				getMap.put(propertyName, method);
            }
        }
        return getMap;
    }
	
	/*
	* Initialise Map of each property name and its corresponding "set...()" method.
	* Note: We only consider "set...()" methods with a single String input argument.
	*/
	private Map<String,Method> initSetMap() {
        Map<String,Method> setMap = new HashMap<String,Method>();
		// By basing the setters we register on the getters we have, we 
		// reduce the chance of considering any "set...()" methods in the 
		// class that are not part of a get/set pair of methods.
        for (Entry<String,Method> getter : getGetters().entrySet()) {
            String getterName = getter.getValue().getName();
            int getterLen = getterName.length();
            String setterName = SET_PREFIX + getterName.substring(GET_PREFIX.length(), getterLen);
            Method setter = getMethod(setterName, String.class);
			if (setter != null) {
				// debug
				//System.err.println(String.format("initSetters() Adding setter for property: %s", setterName));
				setMap.put(getter.getKey(), setter);
			}
        }
        return setMap;
    }
	
	private Method getMethod(String name, Class<?>... params) {
		try {
            return m_propClass.getDeclaredMethod(name, params);
        } catch (Exception e) {
            return null;
        }
    }
	
	/*
	* Return all the current property values in a single Properties object.
	*/ 
	public Properties get(T object) throws IllegalStateException {
		Properties properties = new Properties();
        for (Entry<String, Method> getter : getGetters().entrySet()) {
            Method method = getter.getValue();
			String methodName = method.getName();
			try {
                properties.setProperty(getter.getKey(), method.invoke(object).toString());
			} catch (Exception e) {
				System.err.println("ERROR: get(): " + methodName + ": " + e.getMessage());
			}
		}
		return properties;
	}
	
	/*
	* Invoke the "set...()" method of each property included in the passed Properties object.
	*/
	public void set(T object, Properties properties) throws IllegalArgumentException, IllegalStateException {
        for (Entry<String, Method> setter : getSetters().entrySet()) {
            Method method = setter.getValue();
			String methodName = method.getName();
			String propertyName = setter.getKey();
			
			// Names in the properties file actually start with a lower-case
			// letter, so we down-case the first letter of the name we look up.
			String propertyName2 = initialLowerCase(propertyName);
			String propertyValue = properties.getProperty(propertyName2);
			
			// debug
			//System.err.println(String.format("set() methodName=%s, propertyName=%s, propertyValue=%s", methodName, propertyName2, propertyValue));
						
			try {
				method.invoke(object, propertyValue);
			} catch (Exception e) {
				System.err.println("ERROR: set(): " + methodName + ": " + e.getMessage());
			}
		}
	}
	
	private String initialLowerCase(String str) {
		if ((str == null) || (str.equals(""))) return null;
		char first = str.charAt(0);
		return Character.toLowerCase(first) + str.substring(1);
	}
}
