FROM nvidia/cuda:10.0-devel-ubuntu18.04 
# Grab tini so that Jupyter doesn't spray zombies everywhere
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # Needed for conda
        curl ca-certificates bzip2 procps \ 
        # Needed for builds
        build-essential \
        # Needed for sanity
        vim

# Install conda
RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH

# Install Pytorch
RUN conda install -y pytorch=1.2 -c pytorch && \
    conda clean -ya 

ADD bad.cu good.cu build.ninja run.sh /code/
RUN chmod +x /code/run.sh
WORKDIR /code

