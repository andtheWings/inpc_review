wrangle_funded_by <- function(covidence_extraction_df) {
    
    df1 <-
        covidence_extraction_df |> 
        mutate(
            ahrq_funded = str_detect(funding_source_s, "AHRQ"),
            ags_funded = str_detect(funding_source_s, "Geriatric"),
            anthem_funded = str_detect(funding_source_s, "Anthem"),
            gates_funded = str_detect(funding_source_s, "Melinda"),
            cdc_funded = str_detect(funding_source_s, "CDC"),
            cms_funded = str_detect(funding_source_s, "CMS"),
            cook_funded = str_detect(funding_source_s, "Cook"),
            delta_funded = str_detect(funding_source_s, "Delta"),
            hrsa_funded = str_detect(funding_source_s, "HRSA"),
            idoh_funded = str_detect(funding_source_s, "IDOH"),
            mcphd_funded = str_detect(funding_source_s, "MCPHD"),
            merck_funded = str_detect(funding_source_s, "Merck"),
            nih_funded = str_detect(funding_source_s, "NIH"),
            novartis_funded = str_detect(funding_source_s, "Novartis"),
            onc_funded = str_detect(funding_source_s, "Coordinator"),
            pfizer_funded = str_detect(funding_source_s, "Pfizer"),
            dhhs_funded = str_detect(funding_source_s, "DHHS"),
            fda_funded = str_detect(funding_source_s, "FDA"),
            va_funded = str_detect(funding_source_s, "Veteran"),
            unknown_funded = str_detect(funding_source_s, "Unknown"),
            rwj_funded = str_detect(funding_source_s, "Robert Wood"),
            pew_funded = str_detect(funding_source_s, "Pew"),
            eli_lilly_funded = str_detect(funding_source_s, "Eli Lilly"),
            lilly_endowment_funded = str_detect(funding_source_s, "Lilly Endowment"),
            nsf_funded = str_detect(funding_source_s, "National Science Foundation|NSF"),
            korea_funded = str_detect(funding_source_s, "Korea Research"),
            nvidia_funded = str_detect(funding_source_s, "NVIDIA"),
            nsa_funded = str_detect(funding_source_s, "National Security"),
            georgia_funded = str_detect(funding_source_s, "Georgia"),
            ssa_funded = str_detect(funding_source_s, "Social Security"),
            iu_health_funded = str_detect(funding_source_s, "IU Health"),
            iu_funded = str_detect(funding_source_s, "IUSOM|Indiana University|IUPUI"),
            ibm_funded = str_detect(funding_source_s, "IBM"),
            china_scholardship_funded = str_detect(funding_source_s, "China Scholarship"),
            china_nnsf_funded = str_detect(funding_source_s, "China National Natural"),
            heu_fundamental_funded = str_detect(funding_source_s, "HEU Fundamental"),
            heilongjiang_funded = str_detect(funding_source_s, "Heilongjiang"),
            regenstrief_funded = str_detect(funding_source_s, "Regenstrief"),
            purdue_funded = str_detect(funding_source_s, "Purdue"),
            hartford_funded = str_detect(funding_source_s, "Hartford"),
            central_china_funded = str_detect(funding_source_s, "Central Universities"),
            fairbanks_foundation_funded = str_detect(funding_source_s, "Fairbanks Foundation"),
            methodist_funded = str_detect(funding_source_s, "Methodist Health"),
            not_funded = str_detect(funding_source_s, "None|No funding"),
            roche_funded = str_detect(funding_source_s, "Roche"),
            ibri_funded = str_detect(funding_source_s, "Indiana Biosciences"),
            eastern_surgery_funded = str_detect(funding_source_s, "Surgery of Trauma"),
            medtronic_zipes_funded = str_detect(funding_source_s, "Medtronic"),
            ctsi_funded = str_detect(funding_source_s, "CTSI|Biobank"),
            einstein_aging_funded = str_detect(funding_source_s, "Einstein Aging")
        ) |> 
        # filter(str_detect(funding_source_s, "Other")) |> 
        select(openalex_id, ends_with("funded")) |>  
        pivot_longer(cols = ends_with("funded")) |> 
        filter(value == TRUE) |> 
        mutate(to_institution = str_replace(name, pattern = "_funded", replacement = "")) |>
        select(
            from_openalex_work_id = openalex_id,
            to_institution
        )
    
    return(df1)
    
}