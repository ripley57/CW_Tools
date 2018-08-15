. ./funcs.sh

# Number of parent docs to create
let numberOfParentDocs=1000

# Number of embeddings per doc
let numberOfEmbedsPerDoc=50

let nCurDocID=0
print_Header
for i in $(seq 1 1 $numberOfParentDocs)
do
	let nCurDocID=nCurDocID+1
	print_Parent "$nCurDocID"
	print_Embeds "$nCurDocID" $numberOfEmbedsPerDoc
done
