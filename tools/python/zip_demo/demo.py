# zip is used to combine multiple sequences into one.
# Imagine it is like a zipper, pulling-together one entry from each sequence, to create a tuple.
#
# To run:
#	python3 demo.py

ice_cream_sales = [27, 21, 39, 31, 12, 40, 11, 18, 30, 19, 24, 35, 31, 12]
temperatures =    [75, 97, 88, 99, 81, 92, 84, 84, 93, 99, 86, 90, 75, 79]

ice_cream_data = zip(ice_cream_sales, temperatures)
print(list(ice_cream_data))
