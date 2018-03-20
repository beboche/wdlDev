task computePoorCoverage {
	String SrunLow
	String SampleID
	String OutDir
	String GenomeVersion
	String BedToolsExe
	String AwkExe
	String SortExe
	File IntervalBedFile
	#task specific variables
	Int BedtoolsLowCoverage
	Int BedToolsSmallInterval
	File BamFile

	command {
		${SrunLow} ${BedToolsExe} genomecov -ibam ${BamFile} -bga \
		 | ${AwkExe} -v low_coverage="${BedtoolsLowCoverage}" '$4<low_coverage' \
		 | ${BedToolsExe} intersect -a ${IntervalBedFile} -b - \
		 | ${SortExe} -k1,1 -k2,2n -k3,3n \
		 | ${BedToolsExe} merge -c 4 -o distinct -i - \
		 | ${AwkExe} -v small_intervall="${BedToolsSmallInterval}" \
		 'BEGIN {OFS="\t";print "#chr","start","end","region","size bp","type","UCSC link"} {a=($3-$2+1);if(a<small_intervall) {b="SMALL_INTERVAL"} else {b="OTHER"};url="http://genome-euro.ucsc.edu/cgi-bin/hgTracks?db='${GenomeVersion}'&position="$1":"$2-10"-"$3+10"&highlight='${GenomeVersion}'."$1":"$2"-"$3;print $0, a, b, url}' \
		  > "${OutDir}/${SampleID}/${SampleID}_poor_coverage.txt"
	}
	output {
		poorCoverageFile = "${OutDir}/${SampleID}/${SampleID}_poor_coverage.txt"
	}
}