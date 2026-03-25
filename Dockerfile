FROM rocker/r-ver:4.5.1

LABEL description="seurat_to_anndata: Convert Seurat objects to AnnData"

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libhdf5-dev \
    libglpk-dev \
    libjpeg-dev \
    libpng-dev \
    python3 \
    python3-pip \
    python3-dev \
    python3.12-venv \
    pandoc \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Python packages
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip3 install --no-cache-dir \
    anndata \
    pandas \
    scanpy \
    scipy

# R packages
RUN Rscript -e "\
    install.packages(c('jsonlite', 'Matrix', 'rmarkdown'), \
        repos = 'https://cloud.r-project.org'); \
    install.packages('BiocManager', repos = 'https://cloud.r-project.org'); \
    BiocManager::install(ask = FALSE); \
    install.packages('qs2', repos = 'https://cloud.r-project.org'); \
    install.packages('Seurat', repos = 'https://cloud.r-project.org'); \
    BiocManager::install('Signac', ask = FALSE) \
    "

# Copy scripts
WORKDIR /app
COPY seurat_to_anndata.sh .
COPY make_config.py .
COPY seurat_to_matrix.Rmd .
COPY matrix_to_anndata.py .

RUN chmod +x seurat_to_anndata.sh

# Make callable from command line
ENV PATH="/app:$PATH"

ENTRYPOINT ["seurat_to_anndata.sh"]