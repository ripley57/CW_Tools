function print_Header() 
{
cat <<EOI
"DocID","ParentID","DocType","DateModified","FileName","Text_Content"
EOI
}

function print_Parent()
{
	local nCurDocID="$1"
	local newDocID=$(printf "%08d" $nCurDocID)
	local newFileName=filename$newDocID
	local newTextContent="$(printf "Text content for file %s" $newFileName)"

	cat <<EOI
"$newDocID","","File","2008-01-22T22:36:57.725+0000","$newFileName","$newTextContent"
EOI
}

function print_Embeds()
{
	local parentDocID=$(printf "%08d" "$1")
	local numEmbeds="$2"

	local n
	for n in $(seq 1 1 $numEmbeds)
	do
		let nCurDocID=nCurDocID+1
		local newDocID=$(printf "%08d" $nCurDocID)
		local newFileName=filename$newDocID
		local newTextContent="$(printf "Text content for file %s" $newFileName)"

		cat <<EOI
"$newDocID","$parentDocID","File","2008-01-22T22:36:57.725+0000","$newFileName","$newTextContent"
EOI
	done
}
