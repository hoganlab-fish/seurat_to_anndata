<a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge" alt="MIT License">
</a>

<a href="https://creativecommons.org/licenses/by/4.0/">
    <img src="https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg?style=for-the-badge" alt="CC BY 4.0">
</a>

<a href="https://github.com/hoganlab-fish/seurat_to_anndata">
    <img src="https://img.shields.io/badge/GitHub%2Fhoganlab--fish-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub">
</a>

<a href="https://github.com/hoganlab-fish/seurat_to_anndata/pkgs/container/seurat_to_anndata">
    <img src="https://img.shields.io/badge/docker-257bd6?style=for-the-badge&logo=docker&logoColor=white" alt="Docker Pulls">
</a>

<a href="https://biomedicalsciences.unimelb.edu.au/sbs-research-groups/anatomy-and-physiology-research/stem-cell-and-developmental-biology/hogan-laboratory-vascular-developmental-genetics-and-cell-biology">
    <img src="https://img.shields.io/badge/Website-hoganlab-4285F4?style=for-the-badge&logo=google-chrome&logoColor=white" alt="Website">
</a>

Copyright © 2026 <a href="https://orcid.org/0000-0002-9207-0385">Tyrone Chen <img alt="ORCID logo" src="https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png" width="16" height="16" /></a>, <a href="https://orcid.org/0000-0002-1710-8945">Isaac Virshup <img alt="ORCID logo" src="https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png" width="16" height="16" /></a>, <a href="https://orcid.org/0009-0005-5595-3882">Michelle Meier <img alt="ORCID logo" src="https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png" width="16" height="16" /></a>, <a href="https://orcid.org/0000-0003-3746-0695">Oliver Yu <img alt="ORCID logo" src="https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png" width="16" height="16" /></a>, <a href="https://orcid.org/0009-0005-5595-3882">Elizabeth Mason <img alt="ORCID logo" src="https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png" width="16" height="16" /></a>

Code in this repository is provided under a [MIT license](https://opensource.org/licenses/MIT). This documentation is provided under a [CC-BY-4.0 license](https://creativecommons.org/licenses/by/4.0/).

[Visit our lab website here.](https://www.petermac.org/research/research-programs-and-labs/organogenesis-cancer-program/ben-hogan-lab) Contact Ben Hogan at Ben.Hogan@petermac.org.

# Convert seurat objects to anndata

## Similar packages

`anndataR` as an alternative. [Analogous (and faster) step here](https://bioconductor.org/packages//release/bioc/vignettes/anndataR/inst/doc/usage_seurat.html#writing-a-seurat-object-to-a-h5ad-file):

```
Deconinck L, Zappia L, Cannoodt R, Morgan M, scverse core, Virshup I, Sang-aram C, Bredikhin D, Seurinck R, Saeys Y (2025). anndataR improves interoperability between R and Python in single-cell transcriptomics. bioRxiv, 2025.08.18.669052. doi:10.1101/2025.08.18.669052.
``` 

`SeuratWrappers`, only extracts the first 5000 features.

[https://github.com/satijalab/seurat-wrappers](https://github.com/satijalab/seurat-wrappers). 

`zellkonverter` uses foreign function interfaces (talks to both `R` and `python` using `reticulate` and `conda`).

```
Zappia L, Lun A (2025). zellkonverter: Conversion Between scRNA-seq Objects. doi:10.18129/B9.bioc.zellkonverter, R package version 1.20.1, https://bioconductor.org/packages/zellkonverter.
```

## Quickstart

Run `seurat_to_anndata.sh` with a `Seurat` object as the first argument and an outfile directory as the second argument. Supports `rds` or `qs2` files as input.

Requires memory equivalent to the size of the `Seurat` object. 

```
seurat_to_anndata.sh my_seurat_object.qs2 my_output_directory
```

You will see `h5ad` files per assay in `my_output_directory`. 

> **_NOTE:_** There is also a combined assays file, but it is better to use `muon` to combine which will preserve all features across assays.

A custom `project name` and `config file` can be provided as the 3rd and 4th arguments.

Runtime scales with the number and size of assays and layers in your `Seurat` object.

## Installation

Tested only on `linux red hat enterprise 9.6`.

### Quick install

#### Singularity image

```
docker run ghcr.io/hoganlab-fish/seurat_to_anndata infile.qs2 outdir/
singularity run docker://ghcr.io/hoganlab-fish/seurat_to_anndata infile.qs2 outdir/
```

#### Command line package

*Coming soon*

### Manual install

#### Python

Install through `conda` or `pip`. Tested on `python >= 3.11`.

```
anndata
pandas
scanpy
scipy
```

#### R

Install through `conda` or `install.packages`. Tested on `R >= 4`.

```
jsonlite
Matrix
qs2
rmarkdown
Seurat
Signac
```

#### Detailed environment information

```
anndata         0.12.10 conda-forge
pandas          2.3.3   conda-forge
python          3.14.3  conda-forge
r-base          4.5.3   conda-forge
r-matrix        1.7_4   conda-forge
r-qs2           0.1.7   conda-forge
r-seurat        5.4.0   conda-forge
r-seuratobject  5.3.0   conda-forge
r-signac        1.16.0  bioconda
scipy           1.17.1  conda-forge
```

## Detailed information

1. `seurat_to_anndata.sh` is the main script that calls all other scripts.
2. Calls `make_config.py` to generate a `json` config file with all required metadata. Defaults to `run_config.json` if no custom config name is specified in (1).
3. `seurat_to_matrix.Rmd` reads the config file, extracts data from the Seurat object, exports these to metadata `tsv`, data `mtx`, report `html` files on disk, and logs their file paths to config.
4. `matrix_to_anndata.py` reads the updated config file, ingests metadata `tsv`, data `mtx` files, and exports these to `h5ad` file(s) on disk, and logs their file paths to config.

Each script can run independently but uses the config file for all path information.

You can use the scripts directly by modifying the `json` file if for example you only want to use one part or read/write specific assays. It will export everything it finds by default.

## Sample I/O

`run_config.json`

```
{
  "infile": "infile.qs2|infile.rds",
  "outdir": "outfile_dir",
  "report": "report.html",
  "assays": ["RNA", "ATAC", "SCT", "peaks.lv1"],    # this starts null and updates
  "gene_activity": [],                              # this starts null and updates
  "scvi": {                                         # this starts null and updates
    "detected": true,
    "latent_file": {}
  },
  "metadata": {
    "project": "my_project",
    "date": "2026-03-20 18:24:00.613422"
  }
}
```

Sample `outfile_dir`:

```
├── outfile_dir                 # outfile dir specified
│   ├── ATAC_counts.mtx         # sparse matrices for every assay and layer
│   ├── ATAC_data.mtx
│   ├── ATAC_features.txt
│   ├── ATAC.h5ad               # anndata object for every assay
│   ├── barcodes.txt            # barcodes
│   ├── combined.h5ad           # combined h5ad with anndata
│   ├── combined.h5mu           # combined h5ad with muon
│   ├── integrated.lsi.lv1.csv  # all reductions
│   ├── integrated.lsi.lv2.csv
│   ├── lsi.csv
│   ├── lsi.lv1.csv
│   ├── lsi.lv2.csv
│   ├── metadata.csv            # metadata
│   ├── pca.csv
│   ├── pca.lv2.csv
│   ├── peaks.lv1_counts.mtx    
│   ├── peaks.lv1_data.mtx
│   ├── peaks.lv1_features.txt
│   ├── peaks.lv1.h5ad
│   ├── peaks.lv2_counts.mtx
│   ├── peaks.lv2_data.mtx
│   ├── peaks.lv2_features.txt
│   ├── peaks.lv2.h5ad
│   ├── RNA_counts.mtx
│   ├── RNA_features.txt
│   ├── RNA.h5ad
│   ├── SCT_counts.mtx
│   ├── SCT_data.mtx
│   ├── SCT_features.txt
│   ├── SCT.h5ad
│   ├── SCT_scale.data.mtx
│   ├── scvi_reduction.csv      # scvi-aware
│   ├── scvi_reduction_lv2.csv
│   ├── scvi_umap.csv
│   ├── scvi_umap_lv2.csv
│   ├── umap.csv
│   ├── umap.integrated.lsi.lv1.csv
│   ├── umap.integrated.lsi.lv2.csv
│   ├── umap.joint.integrated.lv1.csv
│   ├── umap.joint.integrated.lv2.csv
│   ├── umap.lsi.lv1.csv
│   ├── umap.lsi.lv2.csv
│   ├── umap.pca.lv1.csv
│   ├── umap.pca.lv2.csv
│   ├── umap.unintegrated.lv1.csv
│   └── umap.unintegrated.lv2.csv
├── run_config.json             # config file
├── report.html       # Rmarkdown report html
└── report.md         # Rmarkdown report md
```