package reflectiondemo;

import java.util.Properties;
import reflectiondemo.PropertyManager;

public class PropFileWrapper {
	private Long m_crawledVolume = null;
	
	private static final PropertyManager<PropFileWrapper> m_propMgr = PropertyManager.forClass(PropFileWrapper.class);
		
	public PropFileWrapper(Properties properties) {
		m_propMgr.set(this, properties);
	}
	
	/*
	* Example "set...()" method for one of the values in the Properties file.
	*/
	public void setCrawledVolume(String crawledVolume) throws IllegalArgumentException {
        try {
            m_crawledVolume = Long.valueOf(crawledVolume);
        }
        catch(NumberFormatException e) {
            throw new IllegalArgumentException(String.format("Bad crawled volume: %s", crawledVolume));
		}
    }
	
	/*
	* Example "get...()" method for one of the values in the Properties file.
	*/
	public long getCrawledVolume() {
        return m_crawledVolume;
    }
}
