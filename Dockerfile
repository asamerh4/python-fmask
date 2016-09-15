#python fmask based on miniconda image...

FROM continuumio/miniconda

#install fmask+deps
RUN conda config --add channels conda-forge &&  conda config --add channels rios && conda create -n myenv python-fmask && conda install -n myenv scipy && groupadd -g 143932 eoc_file.modify_mesos_b && useradd -u 101410 -g 143932 -s /bin/bash f_mesos


#CAUTION: app/snap-4.0 must exist
COPY app /home/f_mesos

RUN apt-get install -y vim && chown -R f_mesos:eoc_file.modify_mesos_b /home/f_mesos && ln -s /opt/conda/envs/myenv/lib/libgeos-3.5.0.so /opt/conda/envs/myenv/lib/libgeos-3.4.2.so && mv /home/f_mesos/gpt.vmoptions /home/f_mesos/snap-4.0/bin/

USER f_mesos
WORKDIR /home/f_mesos