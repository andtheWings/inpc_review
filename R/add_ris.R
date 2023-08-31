add_ris <- function(oa_tbl_df) {
    
    # Binary function to combine two authors
    combine_authors <- function(x, y) {
        paste(x, y, sep = "\nAU  - ")
    } 
    
    # Uses combine_authors to combine all authors in a vector
    ris_authorify <- function(oa_author_df) {
        chr1 <- oa_author_df[["au_display_name"]]
        chr2 <- purrr::reduce(chr1, combine_authors)
        chr3 <- paste0("AU  - ", chr2)
        return(chr3[1])
    }
    
    possibly_ris_authorify <- purrr::possibly(
        ris_authorify,
        otherwise = "AU - "
    )
    
    df1 <-
        oa_tbl_df |> 
        tidyr::separate_wider_regex(
            doi, 
            patterns = c(
                doi_url = "https://doi.org/", 
                doi_id = ".*"
            )
        ) |>
        dplyr::mutate(
            TY = dplyr::case_when(
                type == "article" ~ "JOUR",
                type == "journal-article" ~ "JOUR",
                type == "book-chapter" ~ "CHAP",
                type == "letter" ~ "GEN",
                type == "editorial" ~ "GEN",
                type == "erratum" ~ "GEN",
                type == "other" ~ "GEN"
            ),
            AU = map_chr(author, possibly_ris_authorify),
            ris = paste0(
                "TY  - ",TY,"\n",
                "DO  - ",doi_id,"\n",
                "UR  - ",url,"\n",
                "TI  - ",display_name,"\n",
                "T2  - ",so,"\n",
                AU,"\n",
                "PY  - ",publication_year,"\n",
                "DA  - ",publication_date,"\n",
                "AB  - ",ab,"\n",
                "PB  - ",host_organization,"\n",
                "SP  - ",first_page,"\n",
                "EP  - ",last_page,"\n",
                "IS  - ",issue,"\n",
                "VL  - ",volume,"\n",
                "SN  - ",issn_l,"\n",
                "ER  - "
            )
        ) |> 
        select(-TY, -AU)
    return(df1)
}