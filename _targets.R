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

# Set target-specific options such as packages:
tar_option_set(
    packages = c(
        "dplyr", "purrr", # tidyverse data wrangling
        "openalexR"
    )
)

# End this file with a list of target objects.
list(
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
        name = oa_regenstrief_institution_raw,
        command = oa_fetch(
            entity = "works",
            from_publication_date = "2013-07-01", # Since cut off date for prior review
            to_publication_date = "2023-03-31", # Through first quarter of 2023
            language = "en",
            institutions.ror = "https://ror.org/05f2ywb48"
        )
    ),
    tar_target(
        name = oa_regenstrief_search_raw,
        command = oa_fetch(
            entity = "works",
            from_publication_date = "2013-07-01", # Since cut off date for prior review
            to_publication_date = "2023-03-31", # Through first quarter of 2023
            language = "en",
            search = "regenstrief"
        )
    ),
    tar_target(
        name = oa_iu_title_has_records_raw,
        command = oa_fetch(
            entity = "works",
            from_publication_date = "2013-07-01",
            to_publication_date = "2023-03-31",
            institutions.ror = c(
                "https://ror.org/01kg8sb98", # IU
                "https://ror.org/02k40bc56", # IU Bloomington
                "https://ror.org/05gxnyn08", # IUPUI
                "https://ror.org/01aaptx40", # IU Health
                "https://ror.org/022t7q367" # Indiana CTSI
            ),
            language = "en",
            title.search = "\"electronic health record\" OR EHR OR \"electronic medical record\" OR EMR",
        )
    ),
    tar_target(
        name = oa_iu_abstract_has_records_raw,
        command = oa_fetch(
            entity = "works",
            from_publication_date = "2013-07-01",
            to_publication_date = "2023-03-31",
            institutions.ror = c(
                "https://ror.org/01kg8sb98", # IU
                "https://ror.org/02k40bc56", # IU Bloomington
                "https://ror.org/05gxnyn08", # IUPUI
                "https://ror.org/01aaptx40", # IU Health
                "https://ror.org/022t7q367" # Indiana CTSI
            ),
            language = "en",
            abstract.search = "\"electronic health record\" OR EHR OR \"electronic medical record\" OR EMR",
        )
    ),
    tar_target(
        name = oa_consolidated_records,
        command = list(
            oa_inpc_raw, 
            oa_ihie_raw, 
            oa_regenstrief_institution_raw, 
            oa_regenstrief_search_raw, 
            oa_iu_title_has_records_raw
        ) |>
            reduce(bind_unique_records) |> 
            filter_for_pubmed_pmc_or_doaj() |> 
            add_ris()
    )
    
)
