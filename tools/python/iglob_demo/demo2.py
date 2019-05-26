# Description:
# 	See "Poem puzzle" (Listing 4.9) from Mastering Large Datasets.
#	This program counts the number of instances of "a" and "the"
#	in two sets of text files, corresponding to two different authors.
#
# To run:
#	First we generate about 80MB of random poems:
#	python3 generate_poems.py 
#	NOTE: This will take around 5-10 mins before you start to see poems
#	      being created, in local "author_a" and "author_b" directories.
#	Alternatively, simply extract file "poems.tar.gz"
#
# Example output:
# 	python3 demo2.py 
#
#    	Original_Poem:  0.3
#    	Author One:     0.42
#    	Author Two:     0.22

import toolz
import re, os, itertools
from glob import iglob

def word_ratio(d):
    return float(d.get("a",0))/float(d.get("the",0.0001)) ;# Ensure we don't divide by 0.

class Poem_Cleaner:
    def __init__(self):
        self.r = re.compile(r'[.,;:!-]')

    def clean_poem(self, fp):
        with open(fp) as poem:
            no_punc = self.r.sub(" ", poem.read())
            return no_punc.lower().split()

def word_is_desired(w):
    if w in ["a", "the"]:
        return True
    else: return False

def analyze_poems(poems, cleaner):
    return word_ratio(
        toolz.frequencies(
            filter(word_is_desired, itertools.chain(*map(cleaner.clean_poem, poems)))))

if __name__ == "__main__":
    Cleaner = Poem_Cleaner()
    author1_poems = iglob("author_a/*.txt")
    author2_poems = iglob("author_b/*.txt")

    author1_ratio = analyze_poems(author1_poems, Cleaner)
    author2_ratio = analyze_poems(author2_poems, Cleaner)
 
    print("""
    Original_Poem:  0.3
    Author One:     {:.2f}
    Author Two:     {:.2f}
    """.format(author1_ratio, author2_ratio))

