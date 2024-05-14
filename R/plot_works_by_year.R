plot_works_by_year <- function(works_tbl_df, title_chr = "Works by Year") {
    
    works_tbl_df |> 
    ggplot(aes(x = publication_year)) +
        geom_bar() +
        labs(
            x = "Year",
            y = "Number of INPC Works",
            title = title_chr
        ) +
        theme_bw()
    
}