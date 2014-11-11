FROM debootstrap/debian:testing

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN printf "\ndeb http://ftp.de.debian.org/debian testing main contrib non-free\n deb-src http://ftp.de.debian.org/debian testing main contrib non-free\n\n deb http://ftp.debian.org/debian/ jessie-updates main contrib non-free\n deb-src http://ftp.debian.org/debian/ jessie-updates main contrib non-free\n\n deb http://security.debian.org/ jessie/updates main contrib non-free\n deb-src http://security.debian.org/ jessie/updates main contrib non-free\n" > etc/apt/sources.list \
&& export DEBIAN_FRONTEND=noninteractive \
&& printf "path-exclude=/usr/share/locale/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
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
&& apt-get install -y --no-install-recommends locales \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN apt-get update -qq -y \
&& apt-get install -y --no-install-recommends subversion \
   rsync \
&& cd /tmp \
&& svn co http://svn.r-project.org/R/branches/R-3-1-branch R-patched \
&& cd /tmp/R-patched \
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
   CFLAGS="-march=native -pipe -std=gnu99 -Wall -pedantic -O3"  \
   CXXFLAGS="-march=native -pipe -Wall -pedantic -O3" \
   ./configure --enable-R-shlib \
               --without-blas \
               --without-lapack \
               --with-readline \
&& make \
&& make install \
&& rm -rf /tmp/R-patched \
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
# On my system the gid of group video is 91. I need to change gid of group
# video on ubuntu in order to allow access to video devices when I add them to
# the container.
&& groupmod -g 91 video \
&& usermod -a -G video docker \
&& printf "en_IE.UTF-8 UTF-8\n" >> etc/locale.gen \
&& locale-gen en_IE.UTF-8 \
# set standard repository
&& cd \
&& printf "options(repos=structure(c(CRAN='http://stat.ethz.ch/CRAN/')))\n" > /home/docker/.Rprofile \
# set vim as default editor; vi-editing mode for bash
&& printf "# If not running interactively, don't do anything\n[[ \$- != *i* ]] && return\n\nalias ls='ls --color=auto'\n\nalias grep='grep --color=auto'\n\nPS1='[\u@\h \W]\\$ '\n\ncomplete -cf sudo\n\n# Set default editor.\nexport EDITOR=vim xterm\n\n# Enable vi editing mode.\nset -o vi" > /home/docker/.bashrc \
# Set vi-editing mode for R
&& printf "set editing-mode vi\n\nset keymap vi-command" > /home/docker/.inputrc \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

ENV LANG en_IE.UTF-8
ENV HOME /home/docker
WORKDIR /home/docker
USER docker

ENTRYPOINT ["/usr/local/bin/R"]
