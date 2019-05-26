# Description:
#	Simple reduce demo from Chapter 5 (Listing 5.1) of Mastering Large Datasets.
#
# To run:
#	python3 demo.py

from functools import reduce

xs = [10, 5, 1, 19, 11, 203]

def my_add(acc, nxt):
    return acc + nxt

print(reduce(my_add, xs, 0))

# Using a lambda we can remove the need to declare the my_add() function.
print(reduce(lambda acc,nxt: acc+nxt, xs, 0))
