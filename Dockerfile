FROM ubuntu:15.04
MAINTAINER Stephane Bernigaud 

ENV DEBIAN_FRONTEND noninteractive

#
# Install wine1.7 and a few tools 
#
RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install -y -q software-properties-common
RUN add-apt-repository ppa:ubuntu-wine/ppa -y

RUN apt-get update && apt-get install -y -q	\
	gawk					\
	unzip					\
	wine1.7					\
	wget					\
	xvfb

# Again as root since COPY doesn't honor USER
COPY dotnet_setup.sh /tmp/dotnet_setup3.sh
RUN chmod a+rx /tmp/dotnet_setup3.sh

#
# Create a user to run Captvty
#
RUN useradd --home-dir /home/luser --create-home -K UID_MIN=1000 luser


USER luser
RUN echo "export WINEPREFIX=/home/luser/.wine" >> /home/luser/.bashrc
RUN echo "export WINEARCH=win32" >> /home/luser/.bashrc 
RUN echo "alias ll='ls -als '" >> /home/luser/.bashrc
RUN echo "quiet=on" > /home/luser/.wgetrc

# RUN mkdir -p /home/luser/.wine

WORKDIR /tmp

#
# Install DotNet 4 and some stuff.
# Uses xvfb as a DISPLAY is required.
# Calling each action within a separate xvfb-run makes this fail
# that's why a script is added and then run
#

# RUN HOME=/home/luser xvfb-run /tmp/dotnet_setup3.sh
RUN rm -Rf /home/luser/.wine*
# SB1 RUN xvfb-run wine cmd /c "set"
RUN xvfb-run ./dotnet_setup3.sh


#
# Install Captvty
#
RUN mkdir /home/luser/captvty

# read latest link
RUN echo "Change me to upgrade: v2.4.1" && wget http://captvty.fr -O /tmp/captvty.html 

RUN wget http:$(grep dl\ zip /tmp/captvty.html | cut -d= -f3 | cut -d\" -f2) -O /tmp/captvty.zip


# TODO : get last version ? 
# WARNING: checksum à changer si la version change !!!
# RUN wget http://captvty.fr/?captvty-2.3.9.zip -O ./captvty.zip && sha1sum captvty.zip && sha1sum captvty.zip | awk '$1 != "a40f0ee1e04bc903419baba82f29e4c09d5f9866" { print "Bad checksum"; exit 1; }'										
#RUN wget http://releases.captvty.fr/?captvty-2.3.10.zip -O ./captvty.zip && sha1sum captvty.zip && sha1sum captvty.zip | awk '$1 != "bfd41b75f71fad61f879978472c37a69372ea998" { print "Bad checksum"; exit 1; }'										
#RUN wget --referer=http://captvty.fr http://releases.captvty.fr/?captvty-2.3.10.1.zip -O /tmp/captvty.zip										
RUN unzip /tmp/captvty.zip -d /home/luser/captvty
# Set the download directory
RUN mkdir /home/luser/downloads 

#
# Install a default configuration
#
# RUN cat /home/luser/captvty/captvty.ini | uconv -f UTF-16LE | sed 's/DownloadDir=.*/DownloadDir=Z:\\home\\luser\\downloads\r/' | uconv -t UTF-16LE > /home/luser/captvty/captvty.ini.new && mv -f /home/luser/captvty/captvty.ini.new /home/luser/captvty/captvty.ini
USER root
COPY captvty.ini /home/luser/captvty/
RUN chown luser:luser /home/luser/captvty/captvty.ini

#
# Cleanup
#
USER root
RUN find /tmp -mindepth 1 -exec rm -rf {} +
RUN rm -rf /home/luser/.cache
RUN apt-mark auto 				\
	gawk					\
	unzip					\
	wget					\
	xvfb

RUN apt-get -y -q autoremove
RUN apt-get -y -q clean

COPY autorun.sh /home/luser/autorun.sh
RUN chmod a+rx /home/luser/autorun.sh
RUN chown luser:luser /home/luser/autorun.sh

USER luser
WORKDIR /home/luser


ENTRYPOINT ["/home/luser/autorun.sh"]
