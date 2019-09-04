""" Run this using 'python3 rename_mp3.py' """

import eyed3	# https://pypi.org/project/eyeD3/
import glob
import os


def rename_safe_for_windows(preview=True):
	mp3_files = glob.glob("*.mp3")
	for f in sorted(mp3_files):
		f_old = f
		f_new = f_old.replace(":","-")

		print("f_old={}, f_new={}".format(f_old, f_new))
		if not preview:
			os.rename(f_old, f_new)
	

# Description:
#	Rename all the mp3 files in the current directory.
#
# 	NOTE: 	Edit this function to get the new file names 
#		how you want them.
#
def rename_files(preview=True):
	mp3_files = glob.glob("*.mp3")
	cnt = 0
	for f in sorted(mp3_files):
		cnt += 1
		cnt_str = str(cnt).zfill(4)

		#f_fields =  f.split("_")
		#f0 = f_fields[0]
		#f0 = f0.replace("Part1","")

		f_old = f
		f_new = "{} {}".format(cnt_str, f)

		print("f_old={}, f_new={}".format(f_old, f_new))
		if not preview:
			os.rename(f_old, f_new)


# Description:
#	Set the name of the file as the mp3 title 
#	(minus the ".mp3" file extension).
#
def set_mp3_titles(preview=False):
	mp3_files = glob.glob("*.mp3")
	for f in sorted(mp3_files):
		#  Remove .mp3 extension
		f_fields = os.path.splitext(f)
		new_title = f_fields[0]
		#print("new title={}".format(new_title))

		# Change mp3 title (and other fields).
		audiofile = eyed3.load(f)
		if preview:
			print("file={}, old title={}, new title={}".format(f, audiofile.tag.title, new_title))
		else:
			audiofile.tag.title = new_title
			audiofile.tag.album = u"Dad Audiobooks"
			audiofile.tag.artist = u"Dad Audiobooks"
			audiofile.tag.save()


#rename_files(preview=True)
#set_mp3_titles(preview=True)
#rename_safe_for_windows(preview=True)

