FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

# Update repos
RUN apt-get update -qq
# Run full system upgrade
RUN apt-get dist-upgrade -y

# Install some tools to make life with R easier
RUN apt-get install -y software-properties-common

RUN apt-get install -y --no-install-recommends less
RUN apt-get install -y --no-install-recommends littler
RUN apt-get install -y --no-install-recommends mupdf
# Needed in order to download recommended R packages later on
RUN apt-get install -y --no-install-recommends rsync
RUN apt-get install -y --no-install-recommends vim
RUN apt-get install -y --no-install-recommends wget

# R recommended dependencies
RUN apt-get install -y --no-install-recommends bash-completion
RUN apt-get install -y --no-install-recommends bison
RUN apt-get install -y --no-install-recommends debhelper
RUN apt-get install -y --no-install-recommends default-jdk
RUN apt-get install -y --no-install-recommends gcc
RUN apt-get install -y --no-install-recommends g++
RUN apt-get install -y --no-install-recommends gfortran
RUN apt-get install -y --no-install-recommends groff-base
RUN apt-get install -y --no-install-recommends libblas-dev
RUN apt-get install -y --no-install-recommends libbz2-dev
RUN apt-get install -y --no-install-recommends libcairo2-dev
RUN apt-get install -y --no-install-recommends libjpeg-dev
RUN apt-get install -y --no-install-recommends liblapack-dev
RUN apt-get install -y --no-install-recommends liblzma-dev
RUN apt-get install -y --no-install-recommends libncurses5-dev
RUN apt-get install -y --no-install-recommends libpango1.0-dev
RUN apt-get install -y --no-install-recommends libpcre3-dev
RUN apt-get install -y --no-install-recommends libpng-dev
RUN apt-get install -y --no-install-recommends libreadline-dev
RUN apt-get install -y --no-install-recommends libtiff5-dev
RUN apt-get install -y --no-install-recommends libx11-dev
RUN apt-get install -y --no-install-recommends libxt-dev
RUN apt-get install -y --no-install-recommends mpack
RUN apt-get install -y --no-install-recommends subversion
RUN apt-get install -y --no-install-recommends tcl8.5-dev
RUN apt-get install -y --no-install-recommends texinfo
RUN apt-get install -y --no-install-recommends texlive-base
RUN apt-get install -y --no-install-recommends texlive-extra-utils
RUN apt-get install -y --no-install-recommends texlive-fonts-extra
RUN apt-get install -y --no-install-recommends texlive-fonts-recommended
RUN apt-get install -y --no-install-recommends texlive-generic-recommended
RUN apt-get install -y --no-install-recommends texlive-latex-base
RUN apt-get install -y --no-install-recommends texlive-latex-extra
RUN apt-get install -y --no-install-recommends texlive-latex-recommended
RUN apt-get install -y --no-install-recommends tk8.5-dev
RUN apt-get install -y --no-install-recommends x11proto-core-dev
RUN apt-get install -y --no-install-recommends xauth
RUN apt-get install -y --no-install-recommends xdg-utils
RUN apt-get install -y --no-install-recommends xfonts-base
RUN apt-get install -y --no-install-recommends xvfb
RUN apt-get install -y --no-install-recommends zlib1g-dev
 
# R devel branch
RUN cd /tmp && svn co http://svn.r-project.org/R/trunk R-devel
# R download recommended packages
RUN cd /tmp/R-devel && tools/rsync-recommended

# Build and install
RUN cd /tmp/R-devel && R_PAPERSIZE=a4 \
R_BATCHSAVE="--no-save --no-restore" \
R_BROWSER=xdg-open \
R_PDFVIEWER=mupdf \
PAGER=/usr/bin/less \
PERL=/usr/bin/perl \
R_UNZIPCMD=/usr/bin/unzip \
R_ZIPCMD=/usr/bin/zip \
R_PRINTCMD=/usr/bin/lpr \
LIBnn=lib \
AWK=/usr/bin/awk \
CFLAGS="-pipe -std=gnu99 -Wall -pedantic -O3" \
CXXFLAGS="-pipe -Wall -pedantic -O3" \
./configure

RUN cd /tmp/R-devel && make && make install

# Adding some packages that are required by some R packages
# For R devtools
RUN apt-get install -y --no-install-recommends libcurl4-gnutls-dev
# For lme4 Github version
RUN apt-get install -y --no-install-recommends lmodern

# Set root passwd; change passwd accordingly
RUN echo "root:test" | chpasswd

# Change to your needs
RUN locale-gen en_IE.UTF-8
ENV LANG en_IE.UTF-8

# Add user so that no root-login is required; change username and password
# accordingly
RUN useradd -m chbr
RUN echo "chbr:test" | chpasswd
RUN usermod -s /bin/bash chbr
RUN usermod -aG sudo chbr
ENV HOME /home/chbr
WORKDIR /home/chbr
USER chbr

# set standard repository to download packages from
RUN cd && printf "options(repos=structure(c(CRAN='http://stat.ethz.ch/CRAN/')))\n" > /home/chbr/.Rprofile

# set vim as default editor; vi-editing mode for bash
RUN cd && printf "# If not running interactively, don't do anything\n[[ \$- != *i* ]] && return\n\nalias ls='ls --color=auto'\n\nalias grep='grep --color=auto'\n\nPS1='[\u@\h \W]\\$ '\n\ncomplete -cf sudo\n\n# Set default editor.\nexport EDITOR=vim xterm\n\n# Enable vi editing mode.\nset -o vi" > /home/chbr/.bashrc

# Set vi-editing mode for R
RUN cd && printf "set editing-mode vi\n\nset keymap vi-command" > /home/chbr/.inputrc

CMD []
ENTRYPOINT ["/usr/local/bin/R"]
