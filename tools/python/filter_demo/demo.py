# Description:
# 	Filtering sequences.
#
# To run:
#	sudo apt install python3-pip
#	sudo apt-get install python3-setuptools
#	pip3 install toolz
#
# 	# Now included since Python 3, so no need to install this anymore.
#	#pip3 install itertoolz
#
#	python3 demo.py

# Now included since Python 3.
#from itertoolz import filterfalse
from itertools import filterfalse

# See installation steps above.
from toolz.dicttoolz import keyfilter, valfilter, itemfilter

def is_even(x):
    if x % 2 == 0: return True
    else: return False

def both_are_even(x):
    k,v = x
    if is_even(k) and is_even(v): return True
    else: return False

print(list(filter(is_even, range(10))))
print(list(filterfalse(is_even, range(10))))

# Note: If we wrap these with a "list()" call then we don't print items, i.e. x:y
print(keyfilter(is_even, {1:2, 2:3, 3:4, 4:5, 5:6}))
print(valfilter(is_even, {1:2, 2:3, 3:4, 4:5, 5:6}))
print(itemfilter(both_are_even, {1:5, 2:4, 3:3, 4:2, 5:1}))
