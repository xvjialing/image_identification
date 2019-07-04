FROM registry.cn-hangzhou.aliyuncs.com/xvjialing/image_identification:base

# Install some basic utilities
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  bzip2 \
  libx11-6 \
  wget \
# Install Miniconda
 && wget --no-check-certificate -O miniconda.sh https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh \
 && pwd \
 && ls -a \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && export PATH=$PATH:/root/miniconda/bin \
 && conda update -y -n base -c defaults conda \
 && apt-get autoremove -y wget\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
ENV PATH=/root/miniconda/bin:$PATH
ENV CONDA_AUTO_UPDATE_CONDA=false

# Create a Python 3.7 environment
RUN /root/miniconda/bin/conda install conda-build \
 && /root/miniconda/bin/conda create -y --name py37 python=3.7 \
 && /root/miniconda/bin/conda clean -ya
ENV CONDA_DEFAULT_ENV=py37
ENV CONDA_PREFIX=/root/miniconda/envs/$CONDA_DEFAULT_ENV
ENV PATH=$CONDA_PREFIX/bin:$PATH

# No CUDA-specific steps
ENV NO_CUDA=1
RUN conda install -y -c pytorch \
    pytorch-cpu=1.0.0 \
    torchvision-cpu=0.2.1 \

# Install HDF5 Python bindings
 && conda install -y h5py=2.8.0 \
 && pip install h5py-cache==1.0 \

# Install Torchnet, a high-level framework for PyTorch
 && pip install torchnet==0.0.4 \

# Install Requests, a Python library for making HTTP requests
 && conda install -y requests=2.19.1 \

# Install Graphviz
 && conda install -y graphviz=2.38.0 \
 && pip install graphviz==0.8.4 \

# Install OpenCV3 Python bindings
 && apt-get update \
    && apt-get install -y --no-install-recommends \
    libgtk2.0-0 \
    libcanberra-gtk-module \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && conda install -y -c menpo opencv=3.4.2 \
    && conda clean -ya
    
# install tensorflow flask dependencies
RUN pip install flask Flask-Cors tensorflow==1.13.1 tensorflow-serving-api==1.13.0 xmlrunner
ENV MKL_THREADING_LAYER GNU
