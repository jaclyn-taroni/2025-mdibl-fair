# Build salmon from source in a separate image
FROM ubuntu:22.04 AS build

ENV MDIBL_DOCKER TRUE

# Build dependencies
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake \
    curl \
    g++ \
    gcc \
    libboost-all-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libdeflate-dev \
    libisal-dev \
    liblzma-dev \
    make \
    pkg-config \
    unzip \
    zlib1g-dev \
    && apt-get clean

WORKDIR /usr/local/src

# Build salmon
ARG SALMON_VERSION=1.10.1
RUN curl -LO https://github.com/COMBINE-lab/salmon/archive/refs/tags/v${SALMON_VERSION}.tar.gz
RUN tar xzf v${SALMON_VERSION}.tar.gz
RUN mkdir salmon-${SALMON_VERSION}/build
RUN cd salmon-${SALMON_VERSION}/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/salmon .. && \
    make && make install

# Build fastp
ARG FASTP_VERSION=1.0.0
RUN curl -LO https://github.com/OpenGene/fastp/archive/refs/tags/v${FASTP_VERSION}.tar.gz
RUN tar xzf v${FASTP_VERSION}.tar.gz
RUN cd fastp-${FASTP_VERSION} && \
    make && make install

# Main image with Biocconductor and other tools
FROM ghcr.io/bioconductor/bioconductor_docker:RELEASE_3_21 AS final

WORKDIR /rocker-build/

# Additional dependencies
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    glibc-source \
    groff \
    less \
    libisal2 \
    pipx \
    && apt-get clean

# FastQC
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    fastqc \
    && apt-get clean

# Python packages
COPY requirements.txt requirements.txt
RUN pipx ensurepath
RUN pipx install cookiecutter
RUN pipx runpip cookiecutter install -r requirements.txt

# Use renv for R packages
WORKDIR /usr/local/renv
ENV RENV_CONFIG_CACHE_ENABLED=FALSE
COPY renv.lock renv.lock
RUN R -e "install.packages('renv')"
RUN R -e "renv::restore()" \
    rm -rf ~/.cache/R/renv && \
    rm -rf /tmp/downloaded_packages && \
    rm -rf /tmp/Rtmp*

# copy salmon and fastp binaries from the build image
COPY --from=build /usr/local/salmon/ /usr/local/
COPY --from=build /usr/local/bin/fastp /usr/local/bin/fastp

WORKDIR /home/rstudio

