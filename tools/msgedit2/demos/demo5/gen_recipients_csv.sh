# Description:
#    Bash script to create a single "UPDATE,RECIPIENTS,..." command for msgedit2.exe
#    After running this script in Cygwin, use the generated in.csv as follows:
#    msgedit2.exe -i in.csv
#
# 8/4/2016 JeremyC

cat > in.csv <<EOI
"UPDATE","SUBJECT","d:\demo5\test_email.msg","test email"  
EOI

echo -n "\"UPDATE\",\"RECIPIENTS\",\"d:\demo5\test_email.msg\",\"" >> in.csv

# Change the following number to change the number of recipients.
for (( i=1; i<=500; i++ ))
do
	s=$(printf "test%d <test%d@test%d.com>" $i $i $i)
	echo -n "${s};" >> in.csv
done

cat >> in.csv << EOI
"
EOI
