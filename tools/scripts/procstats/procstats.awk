function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

function gettime(s) { return substr(s,12,8); }
function getdatetime(s) { return substr(s,0,19); }

function printHeader() {
	printf("Date");
	printf(",Batch");
	printf(",Idx start,Idx end,Idx time");
	printf(",Prev Processed");
	printf(",Val start,Val end,Val time");
	printf(",Thr start,Thr end,Thr time");
	printf(",SA start,SA end,SA time");
	printf(",Stat start,Stat end,Stat time");
	printf(",D Mge start,D Mge end,D Mge time");
	printf(",C Mge start,C Mge end,C Mge time");
	printf(",Con time");
	printf(",Total time");
	printf(",Filename\n");
}

function printVals() {
	if (lastfilename=="") {
		printHeader();
		lastfilename=FILENAME;
	}

	if (	(cwdate 		!= "") 	&&
		(cwbatch 		!= "")	&&
		(cwcrawlstart 		!= "")  &&
		(cwcrawlend 		!= "")  &&
		(cwcrawltime 		!= "")  &&
		(cwprevprocessed	!= "")  &&
		(cwvalidatorstart 	!= "")	&&
		(cwvalidatorend 	!= "")	&&
		(cwvalidatortime 	!= "")	&&
		(cwthreadstart		!= "")	&&
		(cwthreadend		!= "")	&&
		(cwthreadertime		!= "")	&&
		(cwsastart		!= "")	&&
		(cwsaend		!= "")	&&
		(cwsatime		!= "")	&&
		(cwstatstart		!= "")	&&
		(cwstatend		!= "")	&&
		(cwstattime		!= "")	&&
		(cwdmergestart		!= "")	&&
		(cwdmergeend		!= "")	&&
		(cwdmergetime		!= "")	&&
		(cwcmergestart		!= "")	&&
		(cwcmergeend		!= "")	&&
		(cwcmergetime		!= "")	&&
		(cwconsolidatortime	!= "")	&&
		(cwtotaltime		!= "")	) {

		printf("%s",	    trim(cwdate));
		printf(",%s",	    trim(cwbatch));
		printf(",%s,%s,%s", cwcrawlstart,cwcrawlend,cwcrawltime);
		printf(",%s", 	    cwprevprocessed);
		printf(",%s,%s,%s", cwvalidatorstart,cwvalidatorend,cwvalidatortime);
		printf(",%s,%s,%s", cwthreadstart,cwthreadend,cwthreadertime);
		printf(",%s,%s,%s", cwsastart,cwsaend,cwsatime);
		printf(",%s,%s,%s", cwstatstart,cwstatend,cwstattime);
		printf(",%s,%s,%s", cwdmergestart,cwdmergeend,cwdmergetime); 
		printf(",%s,%s,%s", cwcmergestart,cwcmergeend,cwcmergetime); 
		printf(",%s",       cwconsolidatortime);
		printf(",%s",       cwtotaltime);
		printf(",%s",	    FILENAME);
		printf("\n");
	}
}

function initVals() {
	  cwdate="";
	  cwbatch="";
	  cwcrawlstart="";
	  cwcrawlend="";
    	  cwcrawltime="";
	  cwprevprocessed="";
    	  cwvalidatorstart="";
    	  cwvalidatorend="";
    	  cwvalidatortime="";
    	  cwthreadstart="";
    	  cwthreadend="";
    	  cwthreadertime="";
    	  cwsastart="";
    	  cwsaend="";
    	  cwsatime="";
    	  cwstatstart="";
    	  cwstatend="";
    	  cwstattime="";
    	  cwdmergestart="";
    	  cwdmergeend="";
    	  cwdmergetime="";
    	  cwcmergestart="";
    	  cwcmergeend="";
    	  cwcmergetime="";
    	  cwconsolidatortime="";
    	  cwtotaltime="";
}

BEGIN {

}

/Job ID: /						{ 
							  initVals();
							  cwjobid=$0; sub(/^Job ID: /,"", cwjobid); 
							}
/Case: /						{ cwcase=$0; sub(/^Case: /,"", cwcase); }
/Appliance: /						{ cwappliance=$0; sub(/^Appliance: /,"", cwappliance); }

/Starting scheduled job: .* : Process documents from/	{ 
							  cwbatch=$0; sub(/^.* in batch "/,"",cwbatch); sub(/"\.$/,"",cwbatch); 
							  cwdate=getdatetime($0);
							}

/Indexer * Starting crawling/				{ cwcrawlstart=gettime($0);  }
/Indexer * Completed/					{ cwcrawlend=gettime($0); }
/Indexer * Previously Processed/			{ 
							  cwprevprocessed=$0; 
							  sub(/^.*Previously Processed /,"",cwprevprocessed); 
							  sub(/,/,"",cwprevprocessed);
							}

/Validator * Starting component/			{ cwvalidatorstart=gettime($0); }
/Validator * 100/					{ cwvalidatorend=gettime($0); }

/Threader * Starting component/				{ cwthreadstart=gettime($0); }
/Threader * 100/					{ cwthreadend=gettime($0); }

/SearchAnalytics * Started/				{ cwsastart=gettime($0); }
/SearchAnalytics * 100/					{ cwsaend=gettime($0); }

/Statistics * Started/					{ cwstatstart=gettime($0); }
/Statistics * 100% completed/				{ cwstatend=gettime($0); }

/DistributedMerge * Starting/				{ cwdmergestart=gettime($0); }
/DistributedMerge * Completed/				{ cwdmergeend=gettime($0); }

/CentralizedMerge * Merging processing results/		{ cwcmergestart=gettime($0); }
/CentralizedMerge * Cleaning up/			{ cwcmergeend=gettime($0); }

/System * Indexer/					{ cwcrawltime=$0; sub(/^.*System[ \t]+Indexer[ \t]+/,"",cwcrawltime); }
/System * Validator/					{ cwvalidatortime=$0; sub(/^.*System[ \t]+Validator[ \t]+/,"",cwvalidatortime); }
/System * Threader/					{ cwthreadertime=$0; sub(/^.*System[ \t]+Threader[ \t]+/,"",cwthreadertime); }
/System * SearchAnalytics/				{ cwsatime=$0; sub(/^.*System[ \t]+SearchAnalytics[ \t]+/,"",cwsatime); }
/System * Statistics/					{ cwstattime=$0; sub(/^.*System[ \t]+Statistics[ \t]+/,"",cwstattime); }
/System * DistributedMerge/				{ cwdmergetime=$0; sub(/^.*System[ \t]+DistributedMerge[ \t]+/,"",cwdmergetime); }
/System * CentralizedMerge/				{ cwcmergetime=$0; sub(/^.*System[ \t]+CentralizedMerge[ \t]+/,"",cwcmergetime); }
/System * Consolidator/					{ cwconsolidatortime=$0; sub(/^.*System[ \t]+Consolidator[ \t]+/,"",cwconsolidatortime); }
/System * Total Processing Time/			{ 
							  cwtotaltime=$0; sub(/^.*System[ \t]+Total Processing Time[ \t]+:[ \t]+/,"",cwtotaltime); 
							  printVals();
							}
END { 

}
