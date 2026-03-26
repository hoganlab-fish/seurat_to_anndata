#!/bin/bash
# run the full conversion workflow
infile_path=$1
outfile_dir=$2
project=$3
outconfig=$4

if [ "$#" -lt 2 ] || [ "$#" -gt 4 ] ; then
    echo "Usage: $0 <infile_path> <outfile_dir> [project_name] [config_file]"
    exit 1
fi

mkdir -p ${2}

# generate config
python make_config.py \
    ${1} \
    ${2} \
    --project ${3} \
    --outconfig ${4}

# r export
Rscript -e "rmarkdown::render(
    'seurat_to_matrix.Rmd', params=list(config='${4}')
)"

# python import
python matrix_to_anndata.py ${4}