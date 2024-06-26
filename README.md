# Research Review of Regenstrief Institute Data Products (RIDP)

This repository lays out code used to query the OpenAlex data catalog for research works that prospectively used data derived from RIDPs. 
This helps the institute assess the research impact of its data services division.

Research works from these queries are uploaded into [Covidence](https://www.covidence.org/) for manual classification as "Included" in the project's scope. 
Research works determined to be "Included" are further reviewed and abstracted in [Baserow](https://baserow.io/). 
Data from these tools are returned to the repository as snapshot files for analysis.

# Getting Started

1.  In your terminal, clone this git repository:

``` bash
git clone https://github.com/andtheWings/inpc_review.git
```

2.  Open your chosen R IDE (e.g. RStudio)
3.  Set up a virtual environment with all needed R packages:

``` r
install.packages("renv")
renv::restore()
```

4. Ensure the "data" folder has the following files and ensure they are listed correctly at the top of the "_targets.R" file:

``` r
### Manually Curated Files
"data/duplicates <snapshot date>.csv"
"data/crosswalks <snapshot date>.csv"
### Downloaded from Covidence
"data/irrelevant covidence works <snapshot date>.csv"
"data/excluded covidence works <snapshot date>.csv"
"data/included covidence works <snapshot date>.csv"
### Downloaded from Baserow (needs to be JSON)
"data/baserow export <snapshot date>.json"
```

5.  Run data pipeline:

``` r
targets::tar_make()
```

6.  List pipeline assets:

``` r
targets::tar_manifest()
```

6.  Load desired pipeline asset (most likely "works" or "included_works"):

``` r
targets::tar_load(<name_of_data_asset>)
```
