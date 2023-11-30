import sys
from labw_utils.bioutils.parser.gtf import GtfIteratorWriter, GtfIterator
from labw_utils.bioutils.datastructure.gene_tree import GeneTree
from labw_utils.bioutils.datastructure.gv.gene import DumbGene

if __name__ == "__main__":
    gt = GeneTree.from_feature_iterator(
        filter(
            lambda record : record.seqname in {"chrM", "MT", "MtDNA", "mitochondrion_genome"},
            GtfIterator(sys.argv[1])
        ),
        gene_implementation=DumbGene,
    )
    w = GtfIteratorWriter(sys.argv[2]) 
    for transcript in gt.transcript_values:
        # TODO: Seems a bug. No idea why.
        if transcript.attribute_get("biotype") == "protein_coding" or \
                transcript.attribute_get("transcript_biotype") == "protein_coding":
            print(f"Written transcript {transcript.transcript_id}")
            w.write(transcript)
            for exon in transcript.exons:
                w.write(exon)
        else:
            print(f"Skipped transcript {transcript.transcript_id}")

# python fetch_mt.py ensembl/gtf/Caenorhabditis_elegans.WBcel235.55.gtf ensembl_mt/ce.gtf
# python fetch_mt.py ensembl/gtf/Drosophila_melanogaster.BDGP6.32.53.gtf ensembl_mt/dm.gtf
# python fetch_mt.py ensembl/gtf/Homo_sapiens.GRCh38.105.gtf ensembl_mt/hs.gtf
# python fetch_mt.py ensembl/gtf/Mus_musculus.GRCm39.105.gtf ensembl_mt/mm.gtf
# gffread -g ensembl/fa/Caenorhabditis_elegans.WBcel235.dna.toplevel.fa -w ensembl_mt/ce.fa ensembl_mt/ce.gtf
# gffread -g ensembl/fa/Drosophila_melanogaster.BDGP6.32.dna.toplevel.fa -w ensembl_mt/dm.fa ensembl_mt/dm.gtf
# gffread -g ensembl/fa/Homo_sapiens.GRCh38.dna.primary_assembly.fa -w ensembl_mt/hs.fa ensembl_mt/hs.gtf
# gffread -g ensembl/fa/Mus_musculus.GRCm39.dna.primary_assembly.fa -w ensembl_mt/mm.fa ensembl_mt/mm.gtf
# minimap2 -a -t 20 ensembl_mt/hs.fa /mnt/volume2/TGS/hESC/origin_ONT_fastq/FINE2a.fastq.gz | samtools view -h -b -F4 | samtools sort -@20 -o ensembl_mt/FINE2a.mm.bam
# samtools index ensembl_mt/FINE2a.mm.bam
# samtools depth -aa  ensembl_mt/FINE2a.mm.bam > ensembl_mt/FINE2a.mm.bam.depth
