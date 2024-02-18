rm(ipak)

uniqueTaxa <- function(phylo, taxa = "Order") {
  taxaList <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
  taxaIndex <- match(taxa, taxaList)
  taxaList <- taxaList[1:taxaIndex]
  
  phyloUnique <- phylo %>%
    tax_table() %>%
    as("matrix") %>%
    as_tibble() %>%
    remove_rownames() %>%
    arrange(Kingdom, Phylum, Class, Order, Family, Genus, Species) %>%
    select (taxaList) %>%
    group_by_at(taxaList) %>%
    dplyr::summarise(n.ASV = n())

  print(phyloUnique)
}

findTaxa <- function(phylo, taxa = "") {
  taxaList <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
  
  phyloList <- phylo %>%
    tax_table() %>%
    as("matrix") %>%
    as_tibble() %>%
    remove_rownames() %>%
    arrange(Kingdom, Phylum, Class, Order, Family, Genus, Species) %>%
    select (taxaList) %>%
    group_by_at(taxaList) %>%
    dplyr::summarise(n.ASV = n()) %>%
    filter(grepl(taxa, paste(Kingdom, Phylum, Class, Order, Family, Genus, Species), ignore.case = TRUE))

    print(phyloList)
}


phyloseq_to_ampvis2 <- function(physeq) {
 #check object for class
 if(!any(class(physeq) %in% "phyloseq"))
   stop("physeq object must be of class \"phyloseq\"", call. = FALSE)

 #ampvis2 requires taxonomy and abundance table, phyloseq checks for the latter
 if(is.null(physeq@tax_table))
   stop("No taxonomy found in the phyloseq object and is required for ampvis2", call. = FALSE)

 #OTUs must be in rows, not columns
 if(phyloseq::taxa_are_rows(physeq))
   abund <- as.data.frame(phyloseq::otu_table(physeq)@.Data)
 else
   abund <- as.data.frame(t(phyloseq::otu_table(physeq)@.Data))

 #tax_table is assumed to have OTUs in rows too
 tax <- phyloseq::tax_table(physeq)@.Data

 #merge by rownames (OTUs)
 otutable <- merge(
   abund,
   tax,
   by = 0,
   all.x = TRUE,
   all.y = FALSE,
   sort = FALSE
 )
 colnames(otutable)[1] <- "OTU"

 #extract sample_data (metadata)
 if(!is.null(physeq@sam_data)) {
   metadata <- data.frame(
     phyloseq::sample_data(physeq),
     row.names = phyloseq::sample_names(physeq),
     stringsAsFactors = FALSE,
     check.names = FALSE
   )

   #check if any columns match exactly with rownames
   #if none matched assume row names are sample identifiers
   # Ajout de as.character(); car SampleID est un vecteur
   samplesCol <- unlist(lapply(metadata, function(x) {
     identical(as.character(x), rownames(metadata))}))

   if(any(samplesCol)) {
     #error if a column matched and it's not the first
     if(!samplesCol[[1]])
       stop("Sample ID's must be in the first column in the sample metadata, please reorder", call. = FALSE)
   } else {
     #assume rownames are sample identifiers, merge at the end with name "SampleID"
     if(any(colnames(metadata) %in% "SampleID"))
       stop("A column in the sample metadata is already named \"SampleID\" but does not seem to contain sample ID's", call. = FALSE)
     metadata$SampleID <- rownames(metadata)

     #reorder columns so SampleID is the first
     metadata <- metadata[, c(which(colnames(metadata) %in% "SampleID"), 1:(ncol(metadata)-1L)), drop = FALSE]
   }
 } else
   metadata <- NULL

 #extract phylogenetic tree, assumed to be of class "phylo"
 if(!is.null(physeq@phy_tree)) {
   tree <- phyloseq::phy_tree(physeq)
 } else
   tree <- NULL

 #extract OTU DNA sequences, assumed to be of class "XStringSet"
 if(!is.null(physeq@refseq)) {
   #convert XStringSet to DNAbin using a temporary file (easiest)
   fastaTempFile <- tempfile(pattern = "ampvis2_", fileext = ".fa")
   Biostrings::writeXStringSet(physeq@refseq, filepath = fastaTempFile)
 } else
   fastaTempFile <- NULL

 #load as normally with amp_load
 ampvis2::amp_load(
   otutable = otutable,
   metadata = metadata,
   tree = tree,
   fasta = fastaTempFile
 )
}