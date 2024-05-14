generate_author_pairs <- function(deduped_authors_tbl_df) {
    
    combn(deduped_authors_tbl_df$deduped_au_id, 2) |>
        t() |>
        as_tibble() |> 
        left_join(deduped_authors_tbl_df, by = c("V1" = "deduped_au_id")) |> 
        select(
            from = V1,
            to = V2,
            from_display = au_display_name,
            work_id = openalex_work_id
        ) |> 
        left_join(deduped_authors_tbl_df, by = c("to" = "deduped_au_id")) |> 
        select(
            from, to, from_display,
            to_display = au_display_name,
            work_id
        )
    
}