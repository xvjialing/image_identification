FROM registry.cn-hangzhou.aliyuncs.com/xvjialing/image_identification:base

# Install some basic utilities
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  wget \
# Install Miniconda
 && wget --no-check-certificate -O miniconda.sh https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh \
 && pwd \
 && ls -a \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && export PATH=$PATH:/root/miniconda/bin \
# && conda update -y -n base -c defaults conda \
 && apt-get autoremove -y wget\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && export PATH=$PATH:/root/miniconda/bin \
 && export CONDA_AUTO_UPDATE_CONDA=false \

# Create a Python 3.7 environment
# && conda install -y conda-build \
 && conda create -y --name py37 python=3.7.3 \
 && export CONDA_DEFAULT_ENV=py37 \
 && export CONDA_PREFIX=/root/miniconda/envs/$CONDA_DEFAULT_ENV \
 && export PATH=$PATH:$CONDA_PREFIX/bin \

# No CUDA-specific steps
 && export NO_CUDA=1 \
 && conda install -y -c pytorch \
    pytorch-cpu=1.0.0 \
    torchvision-cpu=0.2.1 \

# Install Requests, a Python library for making HTTP requests
 && conda install -y requests=2.19.1 \
 
# install tensorflow flask dependencies
 && pip install flask Flask-Cors tensorflow==1.13.1 tensorflow-serving-api==1.13.0 xmlrunner \

# Install OpenCV3 
 && conda install -y -c menpo opencv=3.4.2 \
 && conda clean -ya
    
ENV MKL_THREADING_LAYER GNU
ENV PATH=/root/miniconda/bin:$PATH
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV CONDA_DEFAULT_ENV=py37
ENV CONDA_PREFIX=/root/miniconda/envs/$CONDA_DEFAULT_ENV
ENV PATH=$CONDA_PREFIX/bin:$PATH
ENV NO_CUDA=1



