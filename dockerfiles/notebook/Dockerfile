# malariagen/jupyter-notebook:test6
# jupyter/base-noteobok uploaded 2018-06-13
FROM jupyter/base-notebook:4417b81d04b7

USER root
RUN apt-get update \
  && apt-get install -yq --no-install-recommends libfuse-dev nano fuse vim git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER $NB_USER

RUN conda install --yes \
    -c pyviz/label/dev \
    -c bokeh/channel/dev \
    -c intake \
    -c conda-forge \
    -c bioconda \
    bokeh=0.12.16 \
    cython \
    cytoolz \
    dask=0.18.0 \
    dask-ml \
    datashader \
    distributed=1.22.0 \
    esmpy \
    fastparquet \
    ipywidgets \
    jupyter \
    jupyterlab=0.32.1 \
    jupyterlab_launcher=0.10.5 \
    jupyter_client \
    holoviews \
    libsodium \
    lz4 \
    matplotlib \
    msgpack-python \
    nb_conda_kernels \
    netcdf4 \
    nomkl \
    numba \
    numcodecs \
    numpy=1.14.5 \
    pandas=0.23.1 \
    python-blosc \
    pyzmq \
    s3fs \
    scipy \
    scikit-image \
    scikit-learn \
    toolz=0.9.0 \
    tornado=5.0.2 \
    xarray=0.10.7 \
    zarr=2.2.0 \
    zict \
    intake-xarray \
    bcftools=1.7  \
    bcolz=1.1.2 \
    biopython=1.71 \
    cartopy=0.16.0 \
    fastcluster=1.1.24 \
    graphviz=2.38.0 \
    h5py=2.7.1 \
    htslib=1.7 \
    humanize=0.5.1 \
    intervaltree=2.1.0 \
    joblib=0.11 \
    lmfit=0.9.7 \
    matplotlib=2.2.2 \
    matplotlib-venn=0.11.5 \
    msprime=0.5.0 \
    nbconvert=5.3.1 \
    nose=1.3.7 \
    numexpr=2.6.4 \
    peakutils=1.1.1 \
    pillow=5.1.0 \
    psutil=5.4.3 \
    pyfasta=0.5.2 \
    pysam=0.11.2.2 \
    pysamstats=1.0.1 \
    pytables=3.4.2 \
    pyvcf=0.6.8 \
    samtools=1.7 \
    scikit-allel=1.1.10 \
    scikit-learn=0.19.1 \
    seaborn=0.8.1 \
    toolz=0.9.0 \
    xlrd=1.1.0 \
    && conda clean -tipsy

RUN pip install --upgrade pip

RUN pip install fusepy \
                click \
                jedi \
                kubernetes==6.0.0 \
                dask-kubernetes==0.4.0 \
                gcsfs==0.1.0 \
                xesmf \
                nbserverproxy==0.8.1 \
                --upgrade --no-cache-dir \
                --upgrade-strategy only-if-needed


RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \
                                 @jupyterlab/hub-extension \
                                 @pyviz/jupyterlab_pyviz

RUN jupyter serverextension enable --py nbserverproxy --sys-prefix

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /home/$NB_USER/examples && chown -R $NB_USER /home/$NB_USER/examples
RUN mkdir /pre-home && mkdir /pre-home/examples && chown -R $NB_USER /pre-home
COPY examples/ /pre-home/examples/

ENV DASK_CONFIG=/home/$NB_USER/config.yaml
COPY config.yaml /pre-home
COPY worker-template.yaml /pre-home

RUN mkdir /gcs && chown -R $NB_USER /gcs
RUN mkdir /opt/app

# Add NB_USER to sudo
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
RUN sed -ri "s#Defaults\s+secure_path=\"([^\"]+)\"#Defaults secure_path=\"\1:$CONDA_DIR/bin\"#" /etc/sudoers
USER $NB_USER

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["start.sh jupyter lab"]

