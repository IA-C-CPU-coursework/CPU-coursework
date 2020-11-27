#------------------------------------------------------------------------------
# 🐳
# This Dockerfile creates a image with all required tool for `elec50010-2020-cpu-cw`. 
#
# Quick Start
# $ docker run -it 0x6770/iverilog-mips
#
# It uses a two-stage build process to securely clone from the private repo via ssh-key
# and also save space from building iverilog. 

# The final image is based on Ubuntu 18.04 with `iverilog v11` installed
# along with the following packages, 
#     build-essential
#     git
#     gcc-mipsel-linux-gnu
#     gcc-mips-linux-gnu
#     qemu-system-mips
#     python3
#     cmake
#     verilator
#     libboost-dev
#     parallel 
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Intermediate Stage
# 1. clone coursework repo from github 🚧
# 2. build iverilog v11
#------------------------------------------------------------------------------

FROM ubuntu:18.04 AS intermediate

# update apt source, install git and iverilog dependencies
RUN apt-get update && apt-get install -y \ 
    git \
    bison \
    flex \
    gcc \
    g++ \
    make \
    autoconf \
    gperf 

##=============================================================================
## Please manually clone the coursework to avoid potential exposure of the code.
## I released we are told "any git repo should not be public while the assessment is ongoing"
## 
## # add credentials 
## ARG SSH_PRIVATE_KEY
## RUN mkdir /root/.ssh/
## RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
## RUN chmod 700 /root/.ssh/id_rsa
## RUN eval $(ssh-agent) \
##     ssh-add id_rsa
## 
## # add github.com to known_hosts
## RUN touch /root/.ssh/known_hosts
## RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
## 
## # clone coursework repo to /CPU-coursework
## RUN git clone git@github.com:IA-C-CPU-coursework/CPU-coursework.git /CPU-coursework

# clone and build iverilog from source to /iverilog_build
RUN git clone https://github.com/steveicarus/iverilog.git /iverilog 
RUN cd /iverilog && \
    git checkout --track -b v11-branch origin/v11-branch && \
    sh autoconf.sh && \
    ./configure --prefix=/iverilog_build && \
    make && \
    make install


#------------------------------------------------------------------------------
# Final Stage
# 1. install required tools
# 2. copy coursework repo 🚧
# 3. copy built iverilog
#------------------------------------------------------------------------------

FROM ubuntu:18.04

# Update apt source and install tools required for this project
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    gcc-mipsel-linux-gnu \
    gcc-mips-linux-gnu \
    qemu-system-mips \
    python3 \
    cmake \
    verilator \
    libboost-dev \
    parallel \
    && rm -rf /var/lib/apt/lists/*

# COPY --from=intermediate /CPU-coursework /root/CPU-coursework
COPY --from=intermediate /iverilog_build /iverilog_build
# add `iverilog` binary to PATH so it can be called globally
COPY --from=intermediate /iverilog_build/bin/. /usr/local/bin

