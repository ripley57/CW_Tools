
# Description:
#     Read input_urn.xml. Display specific Message values and esa:nsf duplicate counts.
#
# Comments:
#     If you plan to diff subjects from input_urn.xml with other files, make sure you
#     change the following: &amp;, &apos;, %quot; &lt;, &gt;
#
# Example usage:
#
# sh nsfcount.sh | sort -k2 -nr | head -3
# 0.7.40.123633 7
# 0.7.40.123093 7
# 0.7.40.122899 7
# ...
#
# sh nsfcount.sh | wc -l
# 7900

cat input_urn.xml | awk -F'\n' ' \
/<Message>/    { loc=0; }
/<Locator/     { loc++; ftype=$0; sub(/^.*<Locator location="/, "", ftype); sub(/\/.*$/, "", ftype); }
/DOCID=/       { docid=$0; sub(/^.*DOCID="/, "", docid); sub(/".*$/, "", docid); }
/Subject=/     { s=$0 ; sub(/^.*Subject="[ ]*/,"", s); sub(/".*$/,"", s); }
/Date=/        { t=$0 ; sub(/^.*Date="................/, "", t); t=substr(t,0,5); }
/<\/Message>/  { if (ftype == "esa:nsf") { printf("%s %s %s\n", docid, loc, s); } }'
