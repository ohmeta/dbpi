rule custom_ncbi_refseq_to_kraken2_db:
    input:


rule custom_ncbi_genbank_to_kraken2_db:
    input:


rule ngd_ncbi_refseq_to_kraken2_db:
    input:


rule ngd_ncbi_refseq_to_kraken2_db:
    input:


rule kraken2_16S_gg_db_download:
    input:
        config["16S_gg"]["local_dir"]
    output:
        data = os.path.join(
                config["16S_gg"]["kk2_db"], "data"),
        library = os.path.join(
                config["16S_gg"]["kk2_db"], "library"),
        nodes = os.path.join(
                config["16S_gg"]["kk2_db"], "taxonomy/nodes.dmp"),
        names = os.path.join(
                config["16S_gg"]["kk2_db"], "taxonomy/names.dmp")
    params:
        local_dir = config["16S_gg"]["local_dir"],
        remote_dir = config["16S_gg"]["remote_dir"],
        version = config["16S_gg"]["version"],
        download_no_exists = config["16S_gg"]["download_no_exists"]
    run:
        suffix = params.version + "/" + params.version
        local_fna = os.path.join(
            config["16S_gg"]["local_dir"],
            config["16S_gg"]["version"] + "/" +
            config["16S_gg"]["version"] + ".fasta.gz")
        remote_fna = os.path.join(
            config["16S_gg"]["remote_dir"],
            config["16S_gg"]["version"] + "/" +
            config["16S_gg"]["version"] + ".fasta.gz")

        if !os.path.exists(local_fna):
            if params.download_no_exists:
                shell('''rsync %s %s''' % (remote_fna, local_fna))
            else:
                print("Error:kraken2_16S_gg_db_download: local_dir unavaliable")
                sys.exit(1)

       
rule kraken2_16S_gg_db_preprocess:
    input:

    
rule kraken2_16S_gg_db_build:
    input:
        data = os.path.join(
                config["16S_gg"]["kk2_db"], "data"),
        library = os.path.join(
                config["16S_gg"]["kk2_db"], "library"),
        nodes = os.path.join(
                config["16S_gg"]["kk2_db"], "taxonomy/nodes.dmp"),
        names = os.path.join(
                config["16S_gg"]["kk2_db"], "taxonomy/names.dmp")
    output:
        k2d = expand(
            os.path.join(
                config["16S_gg"]["kk2_db"], "{kk}.k2d"),
            kk=["hash", "opts", "taxo"]),
        map = os.path.join(
            config["16S_gg"]["kk2_db"], "seqid2taxid.map")
    log:
        "logs/kraken2_16S_gg_db.log"
    params:
        ftp_server = config["16S_gg"]["ftp_server"],
        gg_version = config["16S_gg"]["gg_version"],
        donwload_no_exists = config["16S_gg"]["download_no_exists"]
    run:
        shell(
            '''
            kraken2-build \
            --db {output} \
            --build \
            --threads {threads} \
            2> {log}
            ''')
