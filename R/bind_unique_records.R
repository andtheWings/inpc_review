bind_unique_records <- function(a, b) {
    
    df1 <- dplyr::anti_join(
        x = b,
        y = a,
        by = "id"
    )
    
    df2 <- dplyr::bind_rows(
        x = a,
        y = df1
    )
    
    return(df2)
}