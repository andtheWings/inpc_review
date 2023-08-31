filter_for_pubmed_pmc_or_doaj <- function(oa_tbl_df) {
    
    df1 <-
        oa_tbl_df |> 
        dplyr::select(id, oa_status, ids) |> 
        tidyr::unnest(ids) |> 
        dplyr::mutate(
            type = dplyr::case_when(
                stringr::str_detect(ids, "^https://open") ~ "openalex",
                stringr::str_detect(ids, "^https://doi") ~ "doi",
                stringr::str_detect(ids, "^https://www.ncbi") ~ "pmc_id",
                stringr::str_detect(ids, "^https://pubmed") ~ "pubmed_id",
                stringr::str_detect(ids, "^[0-9]") ~ "mag_id"
            )
        ) |> 
        tidyr::pivot_wider(names_from = type, values_from = ids) |> 
        dplyr::filter(oa_status == "gold" | !is.na(pubmed_id) | !is.na(pmc_id))
    
    df2 <- dplyr::semi_join(oa_tbl_df, df1, by = "id")
    
    return(df2)
    
}