wrangle_coauthor_network <- function(works_tbl_df) {
    
    authors <-
        works_tbl_df |> 
        select(openalex_work_id, author) |> 
        unnest(author) |> 
        deduplicate_author_ids()
    
    distinct_authors <- 
        authors |> 
        distinct(deduped_au_id, .keep_all = TRUE)
    
    coauthor_network <-
        authors |> 
        group_split(openalex_work_id) |> 
        map(possibly(generate_author_pairs)) |> 
        reduce(bind_rows) |> 
        as_tbl_graph(directed = FALSE) |> 
        activate(nodes) |> 
        mutate(
            eigen = centrality_eigen(),
            degree = centrality_degree(),
            betweeness = centrality_betweenness(),
            louvain_group = group_louvain()
        ) |> 
        left_join(
            distinct_authors,
            by = c("name" = "deduped_au_id")
        )
    
    return(coauthor_network)
    
}