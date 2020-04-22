rule kraken2_16S_gg_db_download:
    input:
        config["16S_gg"]["local_dir"]
    output:
        fna = os.path.join(
            config["16S_gg"]["local_dir"],
            config["16S_gg"]["version"] + "/" +
            config["16S_gg"]["version"] + ".fasta.gz"),
        taxonomy = os.path.join(
            config["16S_gg"]["local_dir"],
            config["16S_gg"]["version"] + "/" +
            config["16S_gg"]["version"] + "_taxonomy.txt.gz")
    params:
        local_dir = config["16S_gg"]["local_dir"],
        remote_dir = config["16S_gg"]["remote_dir"],
        output_dir = os.path.join(
            config["16S_gg"]["local_dir"],
            config["16S_gg"]["version"]),
        db_version = config["16S_gg"]["version"],
        download_no_exists = config["16S_gg"]["download_no_exists"]
    run:
        fna = os.path.join(
            params.remote_dir,
            params.db_version + "/" +
            params.db_version + ".fasta.gz")

        taxonomy = os.path.join(
            params.remote_dir,
            params.db_version + "/" +
            params.db_version + "_taxonomy.txt.gz")

        if params.download_no_exists:
            shell('''mkdir -p {params.output_dir}''')
            shell('''wget -P {params.output_dir} %s''' % fna)
            shell('''wget -P {params.output_dir} %s''' % taxnomy)
        else:
            print("#Error:kraken2_16S_gg_db_download: {params.local_dir} unavaliable\n")
            shell('''wget -P {params.output_dir} %s''' % fna)
            shell('''wget -P {params.output_dir} %s''' % taxnomy)
            sys.exit(1)

       
rule kraken2_16S_gg_db_preprocess:
    input:
        fna = os.path.join(
            config["16S_gg"]["local_dir"],
            config["16S_gg"]["version"] + "/" +
            config["16S_gg"]["version"] + ".fasta.gz"),
        taxonomy = os.path.join(
            config["16S_gg"]["local_dir"],
            config["16S_gg"]["version"] + "/" +
            config["16S_gg"]["version"] + "_taxonomy.txt.gz")
    output:
        data = directory(os.path.join(
                config["16S_gg"]["kk2_db"], "data")),
        library = os.path.join(
                config["16S_gg"]["kk2_db"], "library/gg.fna"),
        nodes = os.path.join(
                config["16S_gg"]["kk2_db"], "taxonomy/nodes.dmp"),
        names = os.path.join(
                config["16S_gg"]["kk2_db"], "taxonomy/names.dmp"),
        map = os.path.join(
                config["16S_gg"]["kk2_db"], "seqid2taxid.map")
    params:
        db_dir = config["16S_gg"]["kk2_db"],
        db_version = config["16S_gg"]["version"],
        tax_tool = os.path.join(
            os.path.dirname(os.path.realpath(
                shutil.which("kraken2-build"))),
            "build_gg_taxonomy.pl")
    run:
        shell(
            '''
            pushd {params.db_dir}
            mkdir -p data library taxonomy

            pushd data
            gzip -dc {input.fna} > {params.db_version}.fasta
            gzip -dc {input.taxonomy} > {params.db_version}_txonomy.txt

            {params.tax_tool} {params.db_version}_taxonomy.txt
            popd

            mv data/names.dmp data/nodes.dmp taxonomy/
            mv data/seqid2taxid.map .

            mv data/{params.db_version}.fasta library/gg.fna
            popd
            ''')

   
rule kraken2_16S_gg_db_build:
    input:
        data = os.path.join(
            config["16S_gg"]["kk2_db"], "data"),
        library = os.path.join(
            config["16S_gg"]["kk2_db"], "library/gg.fna"),
        nodes = os.path.join(
            config["16S_gg"]["kk2_db"], "taxonomy/nodes.dmp"),
        names = os.path.join(
            config["16S_gg"]["kk2_db"], "taxonomy/names.dmp"),
        map = os.path.join(
            config["16S_gg"]["kk2_db"], "seqid2taxid.map")
    output:
        k2d = expand(
            os.path.join(
                config["16S_gg"]["kk2_db"], "{kk}.k2d"),
            kk=["hash", "opts", "taxo"]),
        map = os.path.join(
            config["16S_gg"]["kk2_db"], "seqid2taxid.map")
    log:
        os.path.join(config["16S_gg"]["kk2_db"],
                     "kraken2_16S_gg_db.log")
    params:
        db_name = config["16S_gg"]["kk2_db"],
        db_version = config["16S_gg"]["version"],
    threads:
        8
    run:
        shell(
            '''
            kraken2-build \
            --db {params.db_name} \
            --build \
            --threads {threads} \
            2> {log}
            ''')


rule kraken2_16S_gg_db_all:
    input:
        expand([
            os.path.join(
                config["16S_gg"]["kk2_db"],
                "{kk}.k2d"),
            os.path.join(
                config["16S_gg"]["kk2_db"],
                "seqid2taxid.map")],
               kk=["hash", "opts", "taxo"])
