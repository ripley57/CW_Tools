# Description: sed match on only part of string.

cat >input.txt <<EOI
trousers aaa yes
trousers bbb no
trousers ccc yes
EOI


sed '/trousers/s/no/yes/' input.txt
