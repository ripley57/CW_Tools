dir /s /b /a:-d src > sources_list.txt
if not exist classes md classes
javac -g -d classes @sources_list.txt
if exist sources_list.txt del sources_list.txt
