# https://veins.car2x.org/tutorial/
# https://omnetpp.org/doc/omnetpp/InstallGuide.pdf
FROM ubuntu:16.04

MAINTAINER Andre Pereira andrespp@gmail.com

# Install dependencies
RUN apt-get update && apt-get install -y xauth unzip wget vim \
	build-essential gcc g++ bison flex perl tcl-dev tk-dev blt \
	libxml2-dev zlib1g-dev default-jre doxygen graphviz \
	libwebkitgtk-1.0-0 openmpi-bin libopenmpi-dev libpcap-dev autoconf \
	automake libtool libproj-dev libgdal1-dev libfox-1.6-dev libgdal-dev \
	libxerces-c-dev qt4-dev-tools \
	qt5-default libqt5opengl5-dev openscenegraph \
	libopenscenegraph-dev openscenegraph-plugin-osgearth  osgearth \
	osgearth-data libosgearth-dev libgeos-dev software-properties-common && \
	add-apt-repository -y ppa:ubuntugis/ppa && \
	apt-get update && apt-get -y install libosgearth-dev

# install vncserver support
RUN apt-get -y install tightvncserver
RUN apt-get -y install x11-xserver-utils
RUN apt-get -y install xfonts-base xfonts-100dpi xfonts-75dpi
ENV USER="root"


# expose ports for ssh
EXPOSE 22
# expose ports for vncserver
# vncserver runs display 1 on port 5901 and display 2 on port 5902, et cetera
EXPOSE 5901

WORKDIR /root

# Build and Install SUMO
# http://sumo.dlr.de/wiki/Installing/Linux_Build
RUN wget https://downloads.sourceforge.net/project/sumo/sumo/version%200.32.0/sumo-src-0.32.0.tar.gz && \
	tar zxf sumo-src-0.32.0.tar.gz && \
	export SUMO_HOME="/root/sumo-0.32.0" && \
	cd sumo-0.32.0/ && \
	./configure && \
	make && \
	make install && \
	cd .. && rm -rf sumo*

# Build and Install OMNet++ IDE
COPY ./omnetpp-5.3-src-linux.tgz ./

RUN	tar zxvf omnetpp-5.3-src-linux.tgz && \
	rm omnetpp-5.3-src-linux.tgz && \
	cd /root/omnetpp-5.3 && \
	export PATH=$PATH:/root/omnetpp-5.3/bin && \
	./configure && \
	make

# Download and Unzip Veins
RUN cd /root && wget https://veins.car2x.org/download/veins-4.7.1.zip && \
	unzip veins-4.7.1.zip && \
	rm veins-4.7.1.zip

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
