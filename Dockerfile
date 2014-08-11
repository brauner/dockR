FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN apt-get update -qq
RUN apt-get dist-upgrade -y
RUN apt-get install -y software-properties-common
RUN apt-get install -y --no-install-recommends less
RUN apt-get install -y --no-install-recommends wget
RUN apt-get install -y --no-install-recommends littler
RUN apt-get install -y --no-install-recommends ssh
RUN apt-get install -y --no-install-recommends xauth

RUN apt-get install -y --no-install-recommends gcc g++ gfortran libblas-dev liblapack-dev tcl8.5-dev tk8.5-dev bison groff-base libncurses5-dev libreadline-dev debhelper texinfo libbz2-dev liblzma-dev libpcre3-dev xdg-utils zlib1g-dev libpng-dev libjpeg-dev libx11-dev libxt-dev x11proto-core-dev libpango1.0-dev libcairo2-dev libtiff5-dev xvfb xauth xfonts-base texlive-base texlive-latex-base texlive-generic-recommended texlive-fonts-recommended texlive-fonts-extra texlive-extra-utils texlive-latex-recommended texlive-latex-extra default-jdk mpack bash-completion subversion 

RUN cd && printf "UsePAM yes\nAllowTcpForwarding yes\nX11Forwarding yes\nX11DisplayOffset 10\nX11UseLocalhost yes\nPrintMotd no # pam does that\nUsePrivilegeSeparation sandbox>.>...# Default for new installations.\nSubsystem>..sftp>.../usr/lib/ssh/sftp-server" > /etc/ssh/sshd_config  

# R devel branch
RUN cd /tmp && svn co http://svn.r-project.org/R/trunk R-devel

## Build and install
RUN cd /tmp/R-devel && R_PAPERSIZE=a4 R_BATCHSAVE="--no-save --no-restore" R_BROWSER=xdg-open PAGER=/usr/bin/pager PERL=/usr/bin/perl R_UNZIPCMD=/usr/bin/unzip R_ZIPCMD=/usr/bin/zip R_PRINTCMD=/usr/bin/lpr LIBnn=lib AWK=/usr/bin/awk CFLAGS="-pipe -std=gnu99 -Wall -pedantic -O3" CXXFLAGS="-pipe -Wall -pedantic -O3" ./configure
RUN cd /tmp/R-devel && make && make install
RUN cd && printf "cd && printf "options(repos=structure(c(CRAN="http://stat.ethz.ch/CRAN/")))\nlibrary(setwidth) " > .Rprofile
