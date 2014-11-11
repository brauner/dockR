FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN printf "path-exclude=/usr/share/locale/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "path-include=/usr/share/locale/en*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "path-exclude=/usr/share/man/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "path-include=/usr/share/man/en*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "path-include=/usr/share/man/man[1-9]/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "path-exclude=/usr/share/i18n/locales/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "path-include=/usr/share/i18n/locales/en_IE*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "path-exclude=/usr/share/i18n/charmaps/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "path-include=/usr/share/i18n/charmaps/UTF-8*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& apt-get update -qq -y \
&& apt-get build-dep -y r-base r-base-dev r-recommended \
&& apt-get install -y --no-install-recommends less \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN apt-get update -qq -y \
&& apt-get install -y --no-install-recommends subversion \
   rsync \
&& cd /tmp \
&& svn co http://svn.r-project.org/R/trunk R-devel \
&& cd /tmp/R-devel \
&& tools/rsync-recommended \
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
               --with-readline \
&& make \
&& make install \
&& rm -rf /tmp/R-devel \
&& apt-get autoremove -y subversion \
   rsync \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Add user
RUN echo "root:test" | chpasswd \
&& useradd -u 1000 -m docker \
&& echo "docker:test" | chpasswd \
&& usermod -s /bin/bash docker \
&& usermod -a -G 100 docker \
# && usermod -a -G sudo docker \
# set standard repository
&& cd \
&& printf "options(repos=structure(c(CRAN='http://stat.ethz.ch/CRAN/')))\n" > /home/docker/.Rprofile

ENV HOME /home/docker
WORKDIR /home/docker
USER docker

ENTRYPOINT ["/usr/local/bin/R"]
