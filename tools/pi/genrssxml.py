#!/usr/bin/python

"""
Python script intended to be called from a cron job on Kodi
in order to generate an RSS XML feed showing the current IP
address and current Geolocation. 

Tested installation location:
/storage/genrssxml.py

Cron setup:
o Launch crontab editor:
  VISUAL=vi crontab -e
o Run this script every 10 mins (no quicker, because we are 
  making Geolocation query):
  */10 * * * *     /storage/genrssxml.py
o Verify setup:
  crontab -l
o Enable cron in the Kodi OpenElec settings.
  Note: Set the RSS update interval in the Kodi settings to 
        1 (miute), as this is the shortest interval possible.
o Create file /storage/.config/autostart.sh and add this:
(
/storage/genrssxml.py
) &
  Note: You must also go to the Kodi Network settings and
        click the option to wait for the network to start,
        since this script connects to the Internet. For
        more details on autostart.sh (and shutdown.sh):
        https://wiki.openelec.tv/documentation/configuration/autostart-sh-and-shutdown-sh 

JeremyC 6-2-2018

"""

import datetime
import json
import urllib, urlparse
import socket, subprocess, re
import xml.etree.ElementTree as ET
from xml.sax.saxutils import escape

from urllib2 import urlopen
from contextlib import closing


def generate_rss_xml_file(params):
    """
    Generate an RSS XML file that Kodi can then refer to locally with an entry
    such as this in file /storage/.kodi/userdata/RssFeeds.xml :

    file://localhost/storage/MyGeneratedRSSFeed.xml

    NOTE: This if the "file://" syntax that includes the hostname. In this example
          we are creating the xml file under "/storage/MyGeneratedRSSFeed.xml".

    NOTE: Kodi config file RssFeeds.xml can be either edited directly, or via the
          Kodi UI.

    XML writing examples: 
    http://stackabuse.com/reading-and-writing-xml-files-in-python/
    """

    # create the xml file structure

    rss_root           = ET.Element('rss')  
    rss_root.set('version','2.0')

    rss_channel        = ET.SubElement(rss_root, 'channel')  
    channel_title      = ET.SubElement(rss_channel, 'title')
    channel_title.text = escape(params['channel_title'])

    # Repeat the eth0 and Geo values multiple times, so we
    # don't have to keep waiting for the text to lap round.
    for x in range(0, 4):
        if 'eth0' in params:
            item1       = ET.SubElement(rss_channel, 'item')  
            title1      = ET.SubElement(item1, 'title')
            title1.text = escape(params['eth0'])

        if 'geo' in params:
            item2       = ET.SubElement(rss_channel, 'item')
            title2      = ET.SubElement(item2, 'title')
            title2.text = escape(params['geo'])

    item3               = ET.SubElement(rss_channel, 'item')
    title3              = ET.SubElement(item3, 'title')
    title3.text         = escape(params['LMD'])

    # create a new XML file with the results
    rss_data    = ET.tostring(rss_root)  
    output_file = open(params['output_file'], "w")  
    output_file.write(rss_data) 


def get_ipv4_address(net_if):
    """
    Returns string of the IP address of the passed network interface (e.g. eth0).
    Parses the output from the Linux ifconfig command to extract the IP address.
    """
    p = subprocess.Popen(["ifconfig"], stdout=subprocess.PIPE)
    ifc_resp = p.communicate()
    re_to_compile = r"^" + re.escape(net_if) + ".*[\n\r]\s*inet\s+addr:(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})"
    patt = re.compile(re_to_compile, re.MULTILINE)
    resp = patt.search(ifc_resp[0])
    return resp.group(1)


def get_geo_location():
    """
    Returns a string of the current Geolocation county name and IP address.
    """
    #url = 'http://freegeoip.net/json/'
    url = 'http://api.ipstack.com/check?access_key=32fb7d383a1d19510cb1cbb96a6fb445&output=json'
    try:
        with closing(urlopen(url)) as response:
            location = json.loads(response.read())
	    location_ip		= location['ip']
            location_city 	= location['city']
            location_state 	= location['region_name']
            location_country	= location['country_name']
            return "" + location_country + " [" + location_ip + "]"
    except Exception as ex:
        return "Geolocation: unknown"
	print(ex)


params = {}

params['channel_title'] = "My RSS Feed"
params['eth0']          = "  " + get_ipv4_address("eth0") + " "
params['lo']            = get_ipv4_address("lo")
params['geo']           = "  Geolocation: " + get_geo_location() + "  "
params['LMD']           = "   Last updated: " + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
params['output_file']   = '/storage/MyGeneratedRSSFeed.xml'

generate_rss_xml_file(params)
