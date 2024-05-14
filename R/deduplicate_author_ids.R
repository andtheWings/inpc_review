deduplicate_author_ids <- function(authors_tbl_df) {
    
    # Identifying Exact Dupes
    # authors |> 
    #     group_by(au_display_name) |> 
    #     summarise(n = n()) |> 
    #     filter(n > 1) |> 
    #     arrange(au_display_name)
    
    # Identifying Fuzzy Dupes
    # library(tidystringdist)
    # 
    # authors |> 
    #     tidy_comb_all(au_display_name) |> 
    #     tidy_stringdist(method = "jw") |> 
    #     arrange(jw)
    
    authors_tbl_df |> 
    mutate(
        deduped_au_id = case_when(
            # Exact Matches
            au_id == "https://openalex.org/A5073247209" ~ "https://openalex.org/A5012639427", #Aaron Cohen-Gadol	 
            au_id == "https://openalex.org/A5083914968" ~ "https://openalex.org/A5011747432", #Huanmei Wu
            ## Two differet Lang Li's
            ## Two different Lei Wang's
            au_id == "https://openalex.org/A5014044536" ~ "https://openalex.org/A5081039323", #Naga Chalasani
            au_id == "https://openalex.org/A5019448909" ~ "https://openalex.org/A5023949037", #Paul Dexter
            au_id == "https://openalex.org/A5053301712" ~ "https://openalex.org/A5090384405", #Shaun Grannis
            au_id == "https://openalex.org/A5028848612" ~ "https://openalex.org/A5088720666", #Titus Schleyer
            au_id == "https://openalex.org/A5059846691" ~ "https://openalex.org/A5089522697", #Xiaochun Li
            ## Two different Xiaolei Huang's
            # Close Matches
            au_id == "https://openalex.org/A5062727105" ~ "https://openalex.org/A5001235782", #P Zhang
            ## Z. Liu different from Z. Li
            ## L. Li different from L Li? (Also different from Lang Li?)
            ## He Tian different from He Jian   
            au_id == "https://openalex.org/A5027076547" ~ "https://openalex.org/A5045855817", #L/Lei Wang
            TRUE ~ au_id
        )
    )
    
}