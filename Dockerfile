FROM continuumio/miniconda

RUN groupadd -g 143932 eoc_file.modify_mesos_b && useradd -u 101410 -g 143932 -s /bin/bash f_mesos

RUN conda config --add channels conda-forge &&  conda config --add channels rios && conda create -n myenv python-fmask


USER f_mesos
WORKDIR /home/f_mesos
