FROM ubuntu:22.04

# Avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# 1. SYSTEM DEPENDENCIES
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
    build-essential git make wget vim ksh tcsh bash \
    python3 python3-dev python3-pip unzip \
    uuid-dev pkg-config bison flex libtool autoconf libz3-dev \
    libx11-6 libx11-6:i386 libxext6 libxext6:i386 \
    libxft2 libxft2:i386 libxrender1 libxrender1:i386 \
    libxtst6 libxtst6:i386 libxpm4 libsm6 libncurses5:i386 \
    libtcl8.6 libtk8.6 libgtk2.0-0 at-spi2-core \
    net-tools numactl dos2unix gtkwave \
    libboost-all-dev \
    && apt-get clean

# 2. DOWNLOAD & INSTALL CMAKE 3.30.1
WORKDIR /tmp
RUN wget https://github.com/Kitware/CMake/releases/download/v3.30.1/cmake-3.30.1-linux-x86_64.sh && \
    chmod +x cmake-3.30.1-linux-x86_64.sh && \
    ./cmake-3.30.1-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.30.1-linux-x86_64.sh

# 3. DOWNLOAD HARM SOURCE (Git Clone)
WORKDIR /opt
# Using --recursive to ensure third_party submodules (Spot, Antlr4) are downloaded
RUN git clone https://github.com/SamueleGerminiani/harm.git --recursive

# 4. HARM THIRD PARTY BUILD
WORKDIR /opt/harm/third_party
RUN bash install_all.sh

# 5. HARM BUILD & INSTALLATION
WORKDIR /opt/harm
RUN mkdir build
WORKDIR /opt/harm/build

ENV CPATH=/opt/harm/third_party/antlr4/runtime/src

RUN cmake -DCMAKE_BUILD_TYPE=Release \
    -DANTLR4_RUNTIME_DIR=/opt/harm/third_party/antlr4/runtime \
    -DSPOTLTL_DIR=/opt/harm/third_party/spot \
    ..

RUN make -j$(nproc)
RUN make install

# 6. ENVIRONMENT & USER SETUP
RUN useradd -u 1000 -m -s /bin/bash user && \
    echo "alias ll='ls -la'" >> /home/user/.bashrc

# Library path setup (Adding HARM and Spot libs explicitly)
ENV LD_LIBRARY_PATH=/usr/local/lib:/opt/harm/third_party/spot/lib:/opt/harm/third_party/antlr4/runtime/lib:/opt/harm/build/lib

USER user
WORKDIR /home/user

# --- EDA CONFIGURATION (Pointing to /opt/eda to avoid shadowing) ---
ENV LM_LICENSE_FILE=1717@157.27.6.46
ENV MGC_HOME=/opt/eda
ENV USER=user
ENV MGC_AMS_HOME=${MGC_HOME}/amsv/qforams/v2021.3_2
ENV TESSENT_HOME=${MGC_HOME}/tessent

# PATH includes HARM build directory AND EDA tool directories
ENV PATH=/opt/harm/build:/usr/local/bin:${MGC_AMS_HOME}/bin:${MGC_AMS_HOME}/linux_x86_64:${TESSENT_HOME}/bin:${PATH}

CMD [ "/bin/bash", "--rcfile", "/home/user/.bashrc" ]