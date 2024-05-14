# Research Review of Regenstrief Institute-Stewarded Data Products (RISDP)

This repository lays out code used to query the OpenAlex data catalog for research works that prospectively used data derived from RISDPs. This helps the institute assess the research impact of its data services division.

Research works from these queries are uploaded into Covidence for manual review of its relevance. Research works determined to be relevant are further reviewed and extracted in the data tool Baserow. The extractions are then returned for analysis to this repository.

# Getting Started

1.  Clone this git repository:

``` bash
git clone https://github.com/andtheWings/inpc_review.git
```

2.  Open your chosen R IDE (e.g. RStudio)
3.  Set up a virtual environment with all needed R packages:

``` r
install.packages("renv")
renv::restore()
```

4.  Run data pipeline to establish data assets:

``` r
targets::tar_make()
```

5.  List data assets:

``` r
targets::tar_manifest()
```

6.  Load desired data asset:

``` r
targets::tar_load(name_of_data_asset)
```
