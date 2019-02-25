FROM continuumio/miniconda3

###############################################
# SciF Base
#
# docker build -t vanessa/cowsay .
# docker run vanessa/cowsay
#
###############################################

ENV DEBIAN_FRONTEND noninteractive

# Dependencies
RUN apt-get update && apt-get install -y wget \
                                         unzip \
                                         apt-utils \
                                         python

# Install scif from pypi
RUN /opt/conda/bin/pip install scif==0.0.75

# Install the filesystem from the recipe
ADD *.scif /
RUN scif install /recipe.scif

# SciF Entrypoint
#ENTRYPOINT ["scif"]

# Import PATH and LB_LIBRARY_PATH
RUN find /scif/apps -maxdepth 2 -name "bin" | while read in; do echo "export PATH=\$PATH:$in" >> /etc/bashrc;done 
RUN if [ -z "${LD_LIBRARY_PATH-}" ]; then echo "export LD_LIBRARY_PATH=/usr/local/lib" >> /etc/bashrc;fi
RUN find /scif/apps -maxdepth 2 -name "lib" | while read in; do echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$in" >> /etc/bashrc;done
