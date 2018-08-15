function ltrim(s) { sub(/^'/, "", s); sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/'$/, "", s); sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

BEGIN {

}

/^[0-9][0-9]*/	{ 
		  split($0, fields, ",");

		  id=fields[1];
		  projectname=trim(fields[2]);
		  position=fields[3];
		  parentid=fields[4];

		  map_id_to_projectname[id]=projectname;
		  map_id_to_position[id]=position;
		  map_id_to_parentid[id]=parentid;

		}

END { 
		for (i in map_id_to_projectname) {
			id=i;
			parentid=map_id_to_parentid[id];
			if (parentid == 0) {
				# No hierarchy to trace back.
				printf("%s\n", map_id_to_projectname[id]);
			} else {
				# Trace back full hierarchy.
				paths="";
				while (parentid != 0) {
					parent_path=map_id_to_projectname[parentid];
					paths=sprintf("%s\\%s", parent_path, map_id_to_projectname[id]);
					id=parentid;
					parentid=map_id_to_parentid[id];
				}	
				printf("%s\n", paths);
			}
		}
}
