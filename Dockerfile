FROM mambaorg/micromamba:latest

USER root

LABEL org.opencontainers.image.description "seurat_to_anndata: Convert Seurat objects to AnnData"

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    pandoc \
    g++ \
    make \
    libgfortran5 \
    libgomp1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# get all pre-compiled binaries
RUN micromamba install -y -n base -c conda-forge -c bioconda \
    r-base=4.5 \
    r-seurat \
    r-signac \
    r-jsonlite \
    r-matrix \
    r-rmarkdown \
    python=3.12 \
    anndata \
    pandas \
    scanpy \
    scipy \
    && micromamba clean --all --yes

# not available for ARM chips sadly
RUN micromamba run -n base \
    Rscript -e "install.packages('qs2', repos='https://cloud.r-project.org')"

# Copy scripts
ENV PATH="/opt/conda/bin:/app:$PATH"
WORKDIR /app

COPY seurat_to_anndata.sh .
COPY make_config.py .
COPY seurat_to_matrix.Rmd .
COPY matrix_to_anndata.py .

RUN chmod +x seurat_to_anndata.sh
ENTRYPOINT ["seurat_to_anndata.sh"]