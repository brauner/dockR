FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN apt-get update -qq \
&& apt-get install -y --no-install-recommends \
   autoconf \
   automake \
   autotools-dev \
   bsdmainutils \
   binutils \
   build-essential \
   ca-certificates \
   cdbs \
   cpp \
   cpp-4.8 \
   debhelper \
   dh-apparmor \
   dh-translations \
   dpkg-dev \
   fontconfig \
   fontconfig-config \
   fonts-dejavu-core \
   g++ \
   g++-4.8 \
   gcc \
   gcc-4.8 \
   gettext \
   gettext-base \
   gfortran \
   gfortran-4.8 \
   groff-base \
   intltool \
   intltool-debian \
   libasan0 \
   libasprintf0c2 \
   libatomic1 \
   libblas-dev \
   libblas3 \
   libbz2-dev \
   libc-dev-bin \
   libc6-dev \
   libcairo2 \
   libcloog-isl4 \
   libcroco3 \
   libdatrie1 \
   libdpkg-perl \
   libencode-locale-perl \
   libfile-listing-perl \
   libfontconfig1 \
   libfreetype6 \
   libgcc-4.8-dev \
   libgfortran-4.8-dev \
   libgfortran3 \
   libglib2.0-0 \
   libgmp10 \
   libgomp1 \
   libgraphite2-3 \
   libharfbuzz0b \
   libhtml-parser-perl \
   libhtml-tagset-perl \
   libhtml-tree-perl \
   libhttp-cookies-perl \
   libhttp-date-perl \
   libhttp-message-perl \
   libhttp-negotiate-perl \
   libice6 \
   libio-html-perl \
   libio-socket-ssl-perl \
   libisl10 \
   libitm1 \
   libjbig0 \
   libjpeg-dev \
   libjpeg-turbo8 \
   libjpeg-turbo8-dev \
   libjpeg8 \
   libjpeg8-dev \
   liblapack-dev \
   liblapack3 \
   liblwp-mediatypes-perl \
   liblwp-protocol-https-perl \
   libmpc3 \
   libmpfr4 \
   libncurses5-dev \
   libnet-http-perl \
   libnet-ssleay-perl \
   libpango-1.0-0 \
   libpangocairo-1.0-0 \
   libpangoft2-1.0-0 \
   libpaper-utils \
   libpaper1 \
   libpcre3-dev \
   libpcrecpp0 \
   libpipeline1 \
   libpixman-1-0 \
   libpng12-dev \
   libpython-stdlib \
   libpython2.7-minimal \
   libpython2.7-stdlib \
   libquadmath0 \
   libreadline-dev \
   libreadline6-dev \
   libsigsegv2 \
   libsm6 \
   libstdc++-4.8-dev \
   libtcl8.5 \
   libthai-data \
   libthai0 \
   libtiff5 \
   libtimedate-perl \
   libtinfo-dev \
   libtk8.5 \
   libtsan0 \
   libunistring0 \
   liburi-perl \
   libwww-perl \
   libwww-robotrules-perl \
   libx11-6 \
   libx11-data \
   libxau6 \
   libxcb-render0 \
   libxcb-shm0 \
   libxcb1 \
   libxdmcp6 \
   libxext6 \
   libxft2 \
   libxml-parser-perl \
   libxml2 \
   libxrender1 \
   libxss1 \
   libxt6 \
   linux-libc-dev \
   m4 \
   make \
   man-db \
   openssl \
   patch \
   po-debconf \
   python \
   python-minimal \
   python-scour \
   python2.7 \
   python2.7-minimal \
   tcl8.5 \
   tk8.5 \
   unzip \
   x11-common \
   xdg-utils \
   xz-utils \
   zip \
   zlib1g-dev \
# further compile dependencies
   bison \
   default-jdk \
   libicu-dev \
   libcairo2-dev \
   liblzma-dev \
   libpango1.0-dev \
   libpng-dev \
   libtiff5-dev \
   libx11-dev \
   libxt-dev \
   mk-configure \
   mpack \
   realpath \
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
   xfonts-base \
# additional tools
   bash-completion \
   littler \
   mupdf \
   vim-tiny \
# For devtools
   libcurl4-gnutls-dev \
&& apt-get clean

RUN apt-get install -y --no-install-recommends subversion \
&& cd /tmp \
&& svn co http://svn.r-project.org/R/branches/R-3-1-branch R-patched \
&& cd /tmp/R-patched \
&& R_PAPERSIZE=a4 \
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
   CFLAGS="-pipe -std=gnu99 -Wall -pedantic -O3"  \
   CXXFLAGS="-pipe -Wall -pedantic -O3" \
   ./configure --enable-R-shlib \
               --without-blas \
               --without-lapack \
               --without-recommended-packages \
               --with-readline \
&& make \
&& make install \
&& rm -rf /tmp/R-patched \
&& apt-get autoremove -y subversion \
&& apt-get clean

# Add user
RUN echo "root:test" | chpasswd \
&& useradd -m rpat \
&& echo "rpat:test" | chpasswd \
&& usermod -s /bin/bash rpat \
&& usermod -aG sudo rpat \
# set standard repository
&& cd \
&& printf "options(repos=structure(c(CRAN='http://stat.ethz.ch/CRAN/')))\n" > /home/rpat/.Rprofile

ENV HOME /home/rpat
WORKDIR /home/rpat
USER rpat

ENTRYPOINT ["/usr/local/bin/R"]
