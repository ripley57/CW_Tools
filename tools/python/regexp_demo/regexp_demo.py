import re

def create_text_file(filename="textfile.txt"):
	file = open(filename, 'w')
	lines = [ 	'this is line one\n', 
			'this is line two hello\n',
			'this is line three\n',
			'this is line four hello hello\n',
			'this\\ten\n', 
			'HELLo there'	]
	file.writelines(lines)
	file.close()

def basic_regexp_demo(filename="textfile.txt"):
	regexp = re.compile("hello|HELLO")
	count = 0
	file = open(filename, 'r')
	for line in file.readlines():
		if regexp.search(line):
			count += 1
	file.close()
	return count

def raw_string_demo(filename="textfile.txt"):
	# If you wanted to search for '\ten' in a string,  you would need to use this:
	# regexp = re.compile("\\\\ten")
	# A better approach is to use "raw strings", to prevent any string
	# processing before the string is passed to the compile() function:
	regexp = re.compile(r"\\ten")
	count = 0
	file = open(filename, 'r')
	for line in file.readlines():
		if regexp.search(line):
			count += 1
	file.close()
	return count

def create_person_file(filename="persons.txt"):
	file = open(filename, 'w')
	lines = [ 	'west, fred michael: 123-123-1234\n',
			'bad format this one: 999-1234\n',
			'senior, trevor: 999-1234\n'	]
	file.writelines(lines)
	file.close()

def extract_demo(filename="persons.txt"):
	regexp = re.compile(	r"(?P<last>[-a-zA-Z]+),"
				r" (?P<first>[-a-zA-Z]+)"
				r"( (?P<middle>([-a-zA-Z]+)))?"
				r": (?P<phone>(\d{3}-)?\d{3}-\d{4})"	)
	file = open(filename, 'r')
	for line in file.readlines():
		result = regexp.search(line)
		if result == None:
			print("Ooops, doesn't look like a record: ({})".format(line.strip()))
		else:
			lastname = result.group('last')
			firstname = result.group('first')
			middlename = result.group('middle')
			if middlename == None:
				middlename = ""
			phonenumber = result.group('phone')
			print('Name:',firstname,middlename,lastname, ' Number:',phonenumber)
	file.close

def replace_basic_demo():
	string = "If the the problem is textual, use the the re module"
	pattern = r"the the"
	regexp = re.compile(pattern)
	print(regexp.sub("the", string))
	

def replace_advanced_demo():
	"""Here we use a function to determine exactly what our replacement substring should be"""
	int_string = "1 2 3 4 5"
	def int_match_to_float(match_obj):
		"""Replace every integer string with a float string"""
		return (match_obj.group('num') + ".0")
	pattern = r"(?P<num>[0-9]+)"
	regexp = re.compile(pattern)
	print(regexp.sub(int_match_to_float, int_string))

create_text_file()
print(basic_regexp_demo())
print(raw_string_demo())

create_person_file()
extract_demo()

replace_basic_demo()
replace_advanced_demo()

