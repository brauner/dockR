FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

# Update repos
RUN apt-get update -qq && apt-get install -y \
    software-properties-common \
    && apt-get install -y --no-install-recommends less \
    littler \
    mupdf \
# Needed in order to download recommended R packages later on
    rsync \
    vim \
    wget \
# 3D support through /dev/dri
    mesa-utils \
# put appropriate dirver for your distribution here:
    i965-va-driver \
    libegl1-mesa \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libopenvg1-mesa \
# R recommended dependencies
    bash-completion \
    bison \
    debhelper \
    default-jdk \
    gcc \
    g++ \
    gfortran \
    groff-base \
    libblas-dev \
    libbz2-dev \
    libcairo2-dev \
    libjpeg-dev \
    liblapack-dev \
    liblzma-dev \
    libncurses5-dev \
    libpango1.0-dev \
    libpcre3-dev \
    libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    libx11-dev \
    libxt-dev \
    mpack \
    subversion \
    tcl8.5-dev \
    texinfo \
    texlive-base \
    texlive-extra-utils \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-latex-recommended \
    tk8.5-dev \
    x11proto-core-dev \
    xauth \
    xdg-utils \
    xfonts-base \
    xvfb \
    zlib1g-dev \
# Adding some packages that are required by some R packages
# For R devtools
    libcurl4-gnutls-dev \
# For lme4 Github version
    lmodern


# R devel branch
RUN cd /tmp && svn co http://svn.r-project.org/R/trunk R-devel \
# R download recommended packages
    && cd /tmp/R-devel && tools/rsync-recommended \
# Build and install
    && cd /tmp/R-devel && R_PAPERSIZE=a4 R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    R_PDFVIEWER=mupdf \
    PAGER=/usr/bin/less \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-march=core-avx-i -pipe -std=gnu99 -Wall -pedantic -O3"  \
    CXXFLAGS="-march=core-avx-i -pipe -Wall -pedantic -O3" \
    ./configure \
    && cd /tmp/R-devel && make && make install

# Add user so that no root-login is required; change username and password
# accordingly
RUN echo "root:test" | chpasswd \
    && useradd -m chbr \
    && echo "chbr:test" | chpasswd \
    && usermod -s /bin/bash chbr \
    && usermod -aG sudo chbr \
    && locale-gen en_IE.UTF-8 \
# set standard repository to download packages from
    cd && printf "options(repos=structure(c(CRAN='http://stat.ethz.ch/CRAN/')))\n" > /home/chbr/.Rprofile \
# set vim as default editor; vi-editing mode for bash
    && cd && printf "# If not running interactively, don't do anything\n[[ \$- != *i* ]] && return\n\nalias ls='ls --color=auto'\n\nalias grep='grep --color=auto'\n\nPS1='[\u@\h \W]\\$ '\n\ncomplete -cf sudo\n\n# Set default editor.\nexport EDITOR=vim xterm\n\n# Enable vi editing mode.\nset -o vi" > /home/chbr/.bashrc \
# Set vi-editing mode for R
    && printf "set editing-mode vi\n\nset keymap vi-command" > /home/chbr/.inputrc
ENV LANG en_IE.UTF-8
ENV HOME /home/chbr
WORKDIR /home/chbr
USER chbr

# Make R run as default process. This is for Docker 1.2 for Docker 1.3 this
# will change and the CMD [] will not be needed anymore.
ENTRYPOINT ["/usr/local/bin/R"]
