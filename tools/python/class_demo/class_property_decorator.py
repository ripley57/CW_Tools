# Note: You must run this with python3

# The '@property' annotation can be used to create a "getter()" method.
# Note that below we cal 't.temp' and not 't.temp()'.

# The '@xxx.setter' annotation can be used to create a "setter()" method.


class Temperature:
	def __init__(self):
		self._temp_fahr = 0
	@property
	def temp(self):
		print("getter called")
		return (self._temp_fahr - 32) * 5 / 9.0
	@temp.setter
	def temp(self, new_temp):
		print("setter called")
		self._temp_fahr = new_temp * 9 / 5 + 32

t = Temperature()

# direct access
#print(t._temp_fahr)

# use the getter
print(t.temp)

# use the setter
t.temp = 34

# direct access
#print(t._temp_fahr)

# getter again
print(t.temp)
