FROM debian:testing

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN export DEBIAN_FRONTEND=noninteractive \
&& export DEBCONF_NONINTERACTIVE_SEEN=true \
&& echo 'deb http://ftp.us.debian.org/debian testing main' > /etc/apt/sources.list \
&& echo 'deb http://ftp.de.debian.org/debian testing main contrib non-free' >> /etc/apt/sources.list \
&& echo 'deb-src http://ftp.de.debian.org/debian testing main contrib non-free' >> /etc/apt/sources.list \
&& echo 'deb http://ftp.debian.org/debian/ testing-updates main contrib non-free' >> /etc/apt/sources.list \
&& echo 'deb-src http://ftp.debian.org/debian/ testing-updates main contrib non-free' >> /etc/apt/sources.list \
&& echo 'deb http://security.debian.org/ testing/updates main contrib non-free' >> /etc/apt/sources.list \
&& echo 'deb-src http://security.debian.org/ testing/updates main contrib non-free' >> /etc/apt/sources.list \
&& apt-get update -qq -y \
&& apt-get install -y --no-install-recommends \
   llvm \
   llvm-dev \
   clang \
   ghostscript \
   imagemagick \
   less \
   libcurl4-gnutls-dev \
   libglu1-mesa-dev \
   libxml2-dev \
   lmodern \
   locales \
   mupdf \
   pandoc \
   texlive-luatex \
   texlive-xetex \
   texlive-lang-german \
   texlive-math-extra \
   vim \
   wget \
   zip \
   unzip \
&& apt-get build-dep -y \
   r-base \
   r-base-dev \
   r-recommended \
&& apt-get clean \
&& cd /var/lib/apt/lists \
&& rm -rf *

RUN export DEBIAN_FRONTEND=noninteractive \
&& export DEBCONF_NONINTERACTIVE_SEEN=true \
&& apt-get update -qq -y \
&& apt-get install -y --no-install-recommends \
   subversion \
   rsync \
&& cd /tmp \
&& svn co http://svn.r-project.org/R/branches/R-3-2-branch R-patched \
&& cd /tmp/R-patched \
&& tools/rsync-recommended \
&& AWK=/usr/bin/awk \
   CFLAGS="-march=ivybridge -pipe -std=gnu99 -Wall -pedantic -O3 -m64"  \
   CXXFLAGS="-march=ivybridge -pipe -Wall -pedantic -O3 -m64" \
   FFLAGS="-march=ivybridge -g -O3 -m64" \
   FCFLAGS="-march=ivybridge -g -O3 -m64" \
   LIBnn=lib \
   PAGER=/usr/bin/less \
   PERL=/usr/bin/perl \
   R_PAPERSIZE=a4 \
   R_BATCHSAVE="--no-save --no-restore" \
   R_BROWSER=xdg-open \
   R_PDFVIEWER=mupdf \
   R_UNZIPCMD=/usr/bin/unzip \
   R_ZIPCMD=/usr/bin/zip \
   R_PRINTCMD=/usr/bin/lpr \
   ./configure --enable-R-shlib \
               --without-blas \
               --without-lapack \
               --with-readline \
&& make \
&& make install \
&& cd /tmp \
&& rm -rf R-patched \
&& apt-get autoremove -y \
   subversion \
   rsync \
&& apt-get clean \
&& cd /var/lib/apt/lists \
&& rm -rf *

# Add user
RUN echo 'root:test' | chpasswd \
&& useradd -u 1000 -m docker \
&& echo 'docker:test' | chpasswd \
&& usermod -s /bin/bash docker \
&& usermod -a -G 100 docker \
&& groupmod -g 91 video \
&& usermod -a -G video docker \
&& groupmod -g 92 audio \
&& usermod -a -G audio docker \
&& cd /etc \
&& printf '\nen_IE.UTF-8 UTF-8\n' >> locale.gen \
&& locale-gen \
&& echo 'Europe/Berlin' > /etc/timezone \
&& dpkg-reconfigure -f noninteractive tzdata \
&& cd /home/docker \
&& printf 'options(repos=structure(c(CRAN='\''http://stat.ethz.ch/CRAN/'\'')))\n' > .Rprofile \
&& printf 'set editing-mode vi\n\nset keymap vi-command\n' > .inputrc \
&& cd /root \
&& printf 'set editing-mode vi\n\nset keymap vi-command\n' > .inputrc

ENV LANG=en_IE.UTF-8 \
    HOME=/home/docker
WORKDIR /home/docker
USER docker

ENTRYPOINT ["/usr/local/bin/R"]
