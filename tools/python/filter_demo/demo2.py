# Description:
#	The filter() method returns an iterator, so we can call next() on it to retrieve each item in the sequence.

words = ["apple","mongoose","walk","mouse","good","pineapple","yeti","minnesota","mars","phone","cream"]

def contains_m(s):
    if "m" in s.lower(): return True
    else: return False

m_words = filter(contains_m, words)

# Note: Iterating is a one-way thing. Once we call next(), there is no way to go backwards.
l = next(m_words)
print(l)
l = next(m_words)
print(l)

print(list(m_words))

