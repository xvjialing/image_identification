FROM ubuntu:18.04
LABEL maintainer "jialing.xu@langyangtech.com"
WORKDIR /root

# install cmake
RUN apt-get update \
    && apt-get -yqq install --no-install-recommends wget build-essential g++ ca-certificates \
    && wget https://github.com/Kitware/CMake/releases/download/v3.14.3/cmake-3.14.3.tar.gz \
    && tar xzvf cmake-3.14.3.tar.gz \
    && rm cmake-3.14.3.tar.gz \
    && mv cmake-3.14.3 /usr/bin/cmake \
    && cd /usr/bin/cmake \
    && ./bootstrap \
    && make \
    && make install \
    && cmake --version \

# install python2.7.9
  && wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz \
  && tar -zxvf Python-2.7.9.tgz \
  && rm Python-2.7.9.tgz \
  && cd Python-2.7.9 \
  && ./configure --prefix=/usr/local/python-2.7.9 \
  && make \
  && make install \
  && ln -s /usr/local/python-2.7.9/bin/python /usr/bin/python2.7.9 \
  && cd .. \
  && rm -rf Python-2.7.9 \

# install jsoncpp and scons
  && wget https://nchc.dl.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz \
  && wget https://jaist.dl.sourceforge.net/project/scons/scons/2.1.0/scons-2.1.0.tar.gz \
  && tar xzvf jsoncpp-src-0.5.0.tar.gz \
  && tar xzvf scons-2.1.0.tar.gz \
  && rm -rf jsoncpp-src-0.5.0.tar.gz scons-2.1.0.tar.gz \
  && cd scons-2.1.0 \
  && python2.7.9 setup.py install \
  && cd ../jsoncpp-src-0.5.0 \
  && scons platform=linux-gcc \
  && cd .. \
  && rm -rf jsoncpp-src-0.5.0 scons-2.1.0 \
  && wget http://47.99.190.254/json.tar.gz \
  && tar xzvf json.tar.gz \
  && rm json.tar.gz \
  && mv json /usr/include/json \
  && cd /usr/include \
  && chmod -R 777 json \

# install tesseract
  && cd /root \
  && apt-get install -y --no-install-recommends\
  automake git libtool libleptonica-dev pkg-config \
  && git clone --depth 1 https://github.com/tesseract-ocr/tesseract.git --branch 4.1 --single-branch \
  && mv tesseract /usr/bin/tesseract \
  && cd /usr/bin/tesseract \
  && rm -rf .git \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make install \
  && ldconfig \

# Install some basic utilities
  && cd /root \
  && apt-get install -y --no-install-recommends \
  bzip2 \
  libx11-6 \
# Install Miniconda
 && wget -O miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh \
 && pwd \
 && ls -a \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && apt-get autoremove -y wget build-essential g++ ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
ENV PATH=/root/miniconda/bin:$PATH
ENV CONDA_AUTO_UPDATE_CONDA=false

# Create a Python 3.6 environment
RUN /root/miniconda/bin/conda install conda-build \
 && /root/miniconda/bin/conda create -y --name py36 python=3.6.5 \
 && /root/miniconda/bin/conda clean -ya
ENV CONDA_DEFAULT_ENV=py36
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
