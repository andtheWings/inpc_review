wrangle_covidence_extraction <- function(covidence_extraction_raw_tbl_df, work_ids_tbl_df) {
    
    
    
    df1 <-
        covidence_extraction_raw_tbl_df |>
        
        # Clean Names
        janitor::clean_names() |>
        
        # Variable management
        rename(
            covidence_name = study_id_2,
            covidence_study_title = title_3
        ) |> 
        select(-study_id_5, -title_6) |> 
        # mutate(
        #     study_id_5 = str_replace(
        #         study_id_5,
        #         "/",
        #         ""
        #     ),
        #     doi = if_else(
        #         str_detect(study_id_5, "doi.org"),
        #         study_id_5,
        #         NA
        #     )
        # )
        
        # Add OpenAlex ID numbers
        left_join(work_ids_tbl_df, by = "covidence_number") |> 
        relocate(openalex_id, .before = covidence_number)

    # Remove non-consensus records
    df2 <-
        df1 |>
        filter(reviewer_name == "Consensus")
    df3 <-
        df1 |>
        anti_join(df2, by = "covidence_number") |>
        bind_rows(df2)
    
    return(df3)
    
}