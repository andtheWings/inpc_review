export_ris_file <- function(oa_tbl_df, export_file_name_chr) {
    
    oa_tbl_df |> 
        add_ris() |> 
        pull(ris) |> 
        cat(sep = "\n\n", file = paste0("citation_exports/",export_file_name_chr,".ris"))
    
    return(paste0("citation_exports/",export_file_name_chr,".ris"))
}
