FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

# Update repos
RUN apt-get update -qq \
&& apt-get install -y \
   software-properties-common \
&& apt-get install -y --no-install-recommends \
   less \
   littler \
   mupdf \
# Needed in order to download recommended R packages later on
   rsync \
   vim \
   wget \
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

# R devel branch
RUN cd /tmp \
&& svn co http://svn.r-project.org/R/trunk R-devel \
# R download recommended packages
&& cd /tmp/R-devel \
&& tools/rsync-recommended \
# Build and install
&& R_PAPERSIZE=a4 R_BATCHSAVE="--no-save --no-restore" \
   R_BROWSER=xdg-open \
   R_PDFVIEWER=mupdf \
   PAGER=/usr/bin/less \
   PERL=/usr/bin/perl \
   R_UNZIPCMD=/usr/bin/unzip \
   R_ZIPCMD=/usr/bin/zip \
   R_PRINTCMD=/usr/bin/lpr \
   LIBnn=lib \
   AWK=/usr/bin/awk \
   CFLAGS="-pipe -std=gnu99 -Wall -pedantic -O3"  \
   CXXFLAGS="-pipe -Wall -pedantic -O3" \
   ./configure --enable-R-shlib \
&& make \
&& make install \
&& rm -rf /tmp/R-devel

# Add user so that no root-login is required; change username and password
# accordingly
RUN echo "root:rdev" | chpasswd \
&& useradd -m rdev \
&& echo "rdev:rdev" | chpasswd \
&& usermod -s /bin/bash rdev \
&& usermod -aG sudo rdev \
# set standard repository to download packages from
&& cd \
&& printf "options(repos=structure(c(CRAN='http://stat.ethz.ch/CRAN/')))\n" > /home/rdev/.Rprofile
ENV HOME /home/rdev
WORKDIR /home/rdev
USER rdev

# Make R run as default process.
ENTRYPOINT ["/usr/local/bin/R"]
