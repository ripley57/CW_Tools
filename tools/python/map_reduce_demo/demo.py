# Description:
#	Simple map reduce demo from Chapter 05 (Listing 5.8) of Mastering Large Datasets.
#
# To run:
#	python3 demo.py

from functools import reduce

# Scrabble-like scoring of a word.
def score_word(word):
    points = 0
    for char in word:
        if char == "z": points += 10
        elif char in ["f","h","v","w"]: points += 5
        elif char in ["b","c","m","p"]: points += 3
        else: points += 1
    return points

words = ["these","are","my","words"]

total_score = reduce(lambda acc,nxt: acc+nxt, map(score_word, words))
print(total_score)
