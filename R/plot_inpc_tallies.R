plot_inpc_tallies <- function(
        baserow_export_tbl_df, 
        tally_variable, 
        top_n = NULL, 
        title_chr = "INPC Tally"
    ) {
    
    df1 <-
        baserow_export_tbl_df |> 
        select(openalex_work_id, {{tally_variable}} ) |>  
        unnest( {{tally_variable}} ) |> 
        mutate(
            transf_tally_variable = fct_infreq(
                as.character( {{tally_variable}} )
            )
        ) |> 
        tabyl(transf_tally_variable) |> 
        mutate(percent = percent * 100) 
    
    if (is.numeric(top_n)) {
        df2 <- slice_max(df1, percent, n = top_n)
    } else{
        df2 <- df1
    }
    
    df2 |>     
        ggplot(aes(x = percent, y = fct_rev(transf_tally_variable))) +
        geom_bar(stat = "identity") +
        labs(
            title = title_chr,
            y = NULL,
            x = "Percent of Works"
        ) +
        theme_bw()
    
    }