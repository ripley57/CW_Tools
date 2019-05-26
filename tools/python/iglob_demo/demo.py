# Description:
#	Find a sequence of files on our filesystem that match a given pattern.
#
# Note: iglob uses lazy file searching, so the memory usage is minimal.
#
# To run:
#	python3 demo.py

from glob import iglob

blog_posts = iglob("blog/posts/*.json")



