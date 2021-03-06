workflow testFastqc {
	call fastqc
}

task fastqc {
	File fastqR1
	File fastqR2
	Int threads
	String tmp_dir
	String out_dir 
	String fastqc
	String sampleID
	#	${fastqc} --threads ${threads} -d ${tmp_dir} ${fastqR1} ${fastqR2} -o ${out_dir}
	command {
		${fastqc} --threads ${threads} ${fastqR1} ${fastqR2}
	}
	output {
		File fastqcHtml = "../inputs/${sampleID}_fastqc.html"
	}
}
