wrangle_baserow_export <- function(baserow_export_raw_list) {
    
    tibble(
        openalex_work_id = map_chr(
            .x = baserow_export_raw_list,
            .f = ~.x$openalex_work_id
        ),
        work_title = map_chr(
            .x = baserow_export_raw_list,
            .f = ~.x$work_title
        ),
        status = map_chr(
            .x = baserow_export_raw_list,
            .f = ~.x$status
        ),
        original_extractor = map_chr(
            .x = baserow_export_raw_list,
            .f = ~.x$original_extractor
        ),
        data_sources_and_augmentations = map(
            .x = baserow_export_raw_list,
            .f = ~.x$data_sources_and_augmentations
        ),
        inpc_and_edw_data_acquisition_methods = map(
            .x = baserow_export_raw_list,
            .f = ~.x$inpc_and_edw_data_acquisition_methods
        ),
        health_areas = map(
            .x = baserow_export_raw_list,
            .f = ~.x$health_areas
        ),
        healthcare_settings = map(
            .x = baserow_export_raw_list,
            .f = ~.x$healthcare_settings
        ),
        ri_service_areas = map(
            .x = baserow_export_raw_list,
            .f = ~.x$ri_service_areas
        ),
        ri_units_of_first_last_authors = map(
            .x = baserow_export_raw_list,
            .f = ~.x$ri_units_of_first_last_authors
        ),
        university_external_partners = map(
            .x = baserow_export_raw_list,
            .f = ~.x$university_external_partners
        ),
        non_university_external_partners = map(
            .x = baserow_export_raw_list,
            .f = ~.x$non_university_external_partners
        ),
        funding_sources = map(
            .x = baserow_export_raw_list,
            .f = ~.x$funding_sources
        ),
        warrants_impact_assessment = map_lgl(
            .x = baserow_export_raw_list,
            .f = ~as.logical(.x$warrants_impact_assessment)
        ),
        potential_impact_areas = map(
            .x = baserow_export_raw_list,
            .f = ~.x$potential_impact_areas
        ),
        international_collaboration = map_lgl(
            .x = baserow_export_raw_list,
            .f = ~as.logical(.x$international_collaboration)
        ),
        any_non_regenstrief_non_iu_collaborators = map_lgl(
            .x = baserow_export_raw_list,
            .f = ~as.logical(.x$any_non_regenstrief_non_iu_collaborators)
        ),
        study_type = map(
            .x = baserow_export_raw_list,
            .f = ~.x$study_type
        )
    )
    
}