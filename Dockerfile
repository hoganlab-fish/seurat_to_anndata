FROM rocker/r-ver:4.5.1

LABEL org.opencontainers.image.description "seurat_to_anndata: Convert Seurat objects to AnnData"

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
    libxt-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \    
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
    options(Ncpus = parallel::detectCores()); \
    install.packages(c('jsonlite', 'Matrix', 'rmarkdown', 'qs2', 'Seurat', 'BiocManager'), \
        repos = 'https://cloud.r-project.org'); \
    BiocManager::install(ask = FALSE); \
    setRepositories(ind = 1:3); \
    install.packages('Signac', repos = 'https://cloud.r-project.org'); \
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