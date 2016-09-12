#python fmask based on miniconda image...

FROM continuumio/miniconda

#add f-account
RUN groupadd -g 143932 eoc_file.modify_mesos_b && useradd -u 101410 -g 143932 -s /bin/bash f_mesos

#install fmask
RUN conda config --add channels conda-forge &&  conda config --add channels rios && conda create -n myenv python-fmask

#install gdal & scipy
RUN apt-get install -y gdal-bin && conda install -n myenv scipy


#permissions
RUN mkdir /home/f_mesos
COPY snap-4.0 /home/f_mesos/snap-4.0
COPY app /home/f_mesos

#RUN mv /home/f_mesos/fmask.py /opt/conda/envs/myenv/lib/python2.7/site-packages/fmask/
RUN chown -R f_mesos:eoc_file.modify_mesos_b /home/f_mesos && chown -R f_mesos:eoc_file.modify_mesos_b /opt/conda

#ENV PATH /opt/conda/envs/myenv/bin:$PATH
#run all ops with this user
USER f_mesos
WORKDIR /home/f_mesos
