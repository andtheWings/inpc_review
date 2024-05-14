library(targets)
# This is an example _targets.R file. Every
# {targets} pipeline needs one.
# Use tar_script() to create _targets.R and tar_edit()
# to open it again for editing.
# Then, run tar_make() to run the pipeline
# and tar_read(data_summary) to view the results.

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.
sapply(
    paste0("R/", list.files("R/")),
    source
)


baserow_export_path <- "data/2023_12_07_baserow_export.json"

preferred_types <- c("article", "book-chapter", "dissertation", "book", "dataset", "other", "report", "standard") #Excludes paratext, reference-entry, peer-review, editorial, erratum, grant, and letter



# Set target-specific options such as packages:
tar_option_set(
    packages = c(
        "dplyr", "purrr", "readr", "stringr", "tidyr", # tidyverse data wrangling
        "openalexR",
        "tidygraph", "ggraph", "networkD3" # Network analysis
    )
)

# End this file with a list of target objects.
list(
    # INPC-specific search results
    tar_target(
        name = oa_inpc_raw,
        command = oa_fetch(
            entity = "works",
            from_publication_date = "2013-07-01", # Since cut off date for prior review
            to_publication_date = "2023-03-31", # Through first quarter of 2023
            language = "en",
            search = "\"indiana network for patient care\"",
        ) 
    ),
    tar_target(
        name = oa_inpc,
        command = oa_inpc_raw |> 
            mutate(source_query = "search for inpc")
    ),
    ## Export INPC-related works for use in Covidence
    # tar_target(
    #     name = A_2023_09_12_df,
    #     command =
    #         oa_inpc_raw |>
    #         filter_for_pubmed_pmc_or_doaj(),
    # ),
    # tar_target(
    #     name = A_2023_09_12,
    #     command =
    #         A_2023_09_12_df |>
    #         export_ris_file("2023-09-12-A"),
    #     format = "file"
    # ),
    # ## Include other INPC search results that are not in an index
    # tar_target(
    #     name = A_2023_09_18,
    #     command =
    #         anti_join(oa_inpc_raw, A_2023_09_12_df, by = "id") |>
    #         export_ris_file("2023-09-18-A"),
    #     format = "file"
    # ),
    
    
    # IHIE-specific search results
    tar_target(
        name = oa_ihie_raw,
        command = oa_fetch(
            entity = "works",
            from_publication_date = "2013-07-01", # Since cut off date for prior review
            to_publication_date = "2023-03-31", # Through first quarter of 2023
            language = "en",
            search = "\"indiana health information exchange\"",
        ) 
    ),
    tar_target(
        name = oa_ihie,
        command = oa_ihie_raw |> 
            mutate(source_query = "search for ihie")
    ),
    tar_target(
        name = oa_ihie_unique,
        command = anti_join(oa_ihie, oa_inpc, by = "id")
    ),
    tar_target(
        name = oa_inpc_ihie_cumulative,
        command =
            reduce(
                .x = list(oa_inpc, oa_ihie),
                .f = bind_unique_records
            )
    ),
    ## Export unique IHIE-related works for use in Covidence
    # tar_target(
    #     name = B_2023_09_18,
    #     command = export_ris_file(oa_ihie_unique, "2023-09-18-B")
    # ),
    
    # Regenstrief Institution Search Results
    tar_target(
        name = oa_regenstrief_institution_raw,
        command = oa_fetch(
            entity = "works",
            from_publication_date = "2013-07-01", # Since cut off date for prior review
            to_publication_date = "2023-03-31", # Through first quarter of 2023
            language = "en",
            institutions.ror = "https://ror.org/05f2ywb48",
            type = preferred_types
        ) 
    ),
    tar_target(
        name = oa_regenstrief_institution,
        command = 
            oa_regenstrief_institution_raw |> 
            filter_for_pubmed_pmc_or_doaj() |> 
            mutate(source_query = "regenstrief is affiliated institution")
    ),
    tar_target(
        name = oa_regenstrief_institution_unique,
        command = anti_join(
            oa_regenstrief_institution, 
            oa_inpc_ihie_cumulative, 
            by = "id"
        )
    ),
    tar_target(
        name = oa_inpc_ihie_institution_cumulative,
        command =
            reduce(
                .x = list(oa_inpc, oa_ihie, oa_regenstrief_institution),
                .f = bind_unique_records
            ) |> 
            anti_join(
                oa_duplicates, 
                by = c("id" = "dupe_id")
            )
    ),
    ## Export unique works where Regenstrief was an affiliated institution
    # tar_target(
    #     name = A_2023_11_01,
    #     command = 
    #         export_ris_file(
    #             oa_regenstrief_institution_unique,
    #             "2023-11-01-A"
    #         )
    # ),
    
    # tar_target(
    #     name = oarenv_regenstrief_search_raw,
    #     command = oa_fetch(
    #         entity = "works",
    #         from_publication_date = "2013-07-01", # Since cut off date for prior review
    #         to_publication_date = "2023-03-31", # Through first quarter of 2023
    #         language = "en",
    #         search = "regenstrief"
    #     )
    # ),
    # tar_target(
    #     name = oa_iu_title_has_records_raw,
    #     command = oa_fetch(
    #         entity = "works",
    #         from_publication_date = "2013-07-01",
    #         to_publication_date = "2023-03-31",
    #         institutions.ror = c(
    #             "https://ror.org/01kg8sb98", # IU
    #             "https://ror.org/02k40bc56", # IU Bloomington
    #             "https://ror.org/05gxnyn08", # IUPUI
    #             "https://ror.org/01aaptx40", # IU Health
    #             "https://ror.org/022t7q367" # Indiana CTSI
    #         ),
    #         language = "en",
    #         title.search = "\"electronic health record\" OR EHR OR \"electronic medical record\" OR EMR",
    #     )
    # ),
    # tar_target(
    #     name = oa_iu_abstract_has_records_raw,
    #     command = oa_fetch(
    #         entity = "works",
    #         from_publication_date = "2013-07-01",
    #         to_publication_date = "2023-03-31",
    #         institutions.ror = c(
    #             "https://ror.org/01kg8sb98", # IU
    #             "https://ror.org/02k40bc56", # IU Bloomington
    #             "https://ror.org/05gxnyn08", # IUPUI
    #             "https://ror.org/01aaptx40", # IU Health
    #             "https://ror.org/022t7q367" # Indiana CTSI
    #         ),
    #         language = "en",
    #         abstract.search = "\"electronic health record\" OR EHR OR \"electronic medical record\" OR EMR",
    #     )
    # ),
    # tar_target(
    #     name = oa_consolidated_records,
    #     command = list(
    #         oa_inpc_raw, 
    #         oa_ihie_raw, 
    #         oa_regenstrief_institution_raw, 
    #         oa_regenstrief_search_raw, 
    #         oa_iu_title_has_records_raw
    #     ) |>
    #         reduce(bind_unique_records) |> 
    #         filter_for_pubmed_pmc_or_doaj() |> 
    #         add_ris()
    # ),
    
    # OpenAlex Duplicate Accounting
    tar_target(
        name = oa_duplicates_file,
        command = "data/duplicates.csv",
        format = "file"
    ),
    tar_target(
        name = oa_duplicates,
        command = read_csv(oa_duplicates_file)
    ),
    
    # Baserow Extraction Data
    tar_target(
        name = baserow_export_file,
        command = baserow_export_path,
        format = "file"
    ),
    tar_target(
        name = baserow_export_raw,
        command = jsonlite::read_json(baserow_export_file)
    ),
    tar_target(
        name = baserow_export,
        command = wrangle_baserow_export(baserow_export_raw)
    ),
    
    # Analytic Outputs
    tar_target(
        name = inpc_ihie_extractions,
        command = 
            inner_join(
                baserow_export, oa_inpc_ihie_cumulative, 
                by = c("openalex_work_id" = "id")
            ) 
    ),
    tar_target(
        name = coauthor_network,
        command = wrangle_coauthor_network(inpc_ihie_extractions)
    )
    
)
