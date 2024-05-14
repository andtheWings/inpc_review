expand_oa_id_columns <- function(oa_works_tbl_df) {
    
    oa_works_tbl_df |> 
        dplyr::select(id, ids) |> 
        tidyr::unnest(ids) |> 
        dplyr::mutate(
            type = dplyr::case_when(
                stringr::str_detect(ids, "^https://open") ~ "openalex_id",
                stringr::str_detect(ids, "^https://doi") ~ "doi",
                stringr::str_detect(ids, "^https://www.ncbi") ~ "pmc_id",
                stringr::str_detect(ids, "^https://pubmed") ~ "pubmed_id",
                stringr::str_detect(ids, "^[0-9]") ~ "mag_id"
            )
        ) |> 
        tidyr::pivot_wider(names_from = type, values_from = ids) |> 
        dplyr::select(-openalex_id) |> 
        dplyr::right_join(
            dplyr::select(oa_works_tbl_df, -doi), 
            by = "id"
        ) 
    
}