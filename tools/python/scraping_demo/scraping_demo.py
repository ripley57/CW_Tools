""" Demo of scraping a web page using Beautiful Soup 

	To install (Hmm, I didn't need to install this):
	pip install bs4
	or
	python3 -m pip install --user bs4

	NOTE: We will assume that we've already downloaded the page to scrape.

	Documentation:
	https://www.crummy.com/software/BeautifulSoup/bs4/doc/
"""

import bs4

html = open("test.html").read()

bs = bs4.BeautifulSoup(html, "html.parser")
#print(bs.prettify())

# Find a link:
a_list = bs("a")
#print(type(a_list))
print(a_list[0].text)
print(a_list[0].get('href'))

# Find elements with a CSS class of 'special':
special_list = bs.select(".special")
print(special_list)
item = special_list[0]
print(item.text)
print(item["class"])
