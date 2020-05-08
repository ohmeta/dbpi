rule get_assembly_report:
    input:
    output:
        expand("{outdir}/{domain}/assembly_summary.txt",
               outdir=["refseq", "genbank"],
               domain=["archaea", "bacteria", "fungi", "viral"])
    shell:
        '''
        mkdir -p refseq/{archaea,bacteria,fungi,viral}
        mkdir -p genbank/{archaea,bacteria,fungi,viral}

        wget -c -P refseq/archaea https://ftp.ncbi.nlm.nih.gov/genomes/refseq/archaea/assembly_summary.txt
        wget -c -P refseq/bacteria https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt
        wget -c -P refseq/fungi https://ftp.ncbi.nlm.nih.gov/genomes/refseq/fungi/assembly_summary.txt
        wget -c -P refseq/viral https://ftp.ncbi.nlm.nih.gov/genomes/refseq/viral/assembly_summary.txt

        wget -c -P genbank/archaea https://ftp.ncbi.nlm.nih.gov/genomes/genbank/archaea/assembly_summary.txt
        wget -c -P genbank/bacteria https://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/assembly_summary.txt
        wget -c -P genbank/fungi https://ftp.ncbi.nlm.nih.gov/genomes/genbank/fungi/assembly_summary.txt
        wget -c -P genbank/viral https://ftp.ncbi.nlm.nih.gov/genomes/genbank/viral/assembly_summary.txt
        '''


rule check_genomic_fna:
    input:
        expand("{outdir}/{domain}/assembly_summary.txt",
               outdir=["refseq", "genbank"],
               domain=["archaea", "bacteria", "fungi", "viral"])
    output:
    shell:
