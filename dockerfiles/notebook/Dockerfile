FROM jupyter/base-notebook

USER root
RUN apt-get  update 


RUN apt-get update \
  && apt-get install -yq --no-install-recommends libfuse-dev nano fuse vim git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER $NB_USER

RUN pip install --upgrade pip

RUN pip install fusepy click jedi kubernetes \
        gcsfs \
	--upgrade --no-cache-dir

RUN conda update -n base conda
RUN conda install nb_conda_kernels
RUN conda create -n malariagen python=3.5 

RUN conda install -n malariagen --yes -c defaults -c pyviz/label/dev -c bokeh/channel/dev -c intake -c bioconda  \
    htslib=1.7 \
    pysam=0.11.2.2 \
    samtools=1.7 \
    snakemake=4.8.0 \
    pysamstats=1.0.1 \
    pyfasta=0.5.2	 \
    pyvcf=0.6.8 \
    bokeh=0.12.16 \
    cytoolz=0.9.0.1 \
    dask=0.17.2 \
    fastcluster=1.1.24 \
    h5py=2.7.1 \
    humanize=0.5.1 \
    intervaltree=2.1.0 \
    ipykernel=4.8.2 \
    ipython=6.3.1 \
    ipywidgets=7.2.0 \
    joblib=0.11 \
    jupyter_console=5.2.0 \
    lmfit=0.9.7 \
    matplotlib=2.2.2 \
    matplotlib-venn=0.11.5 \
    msprime=0.5.0 \
    nbconvert=5.3.1 \
    nose=1.3.7 \
    notebook=5.4.1 \
    numcodecs=0.5.5 \
    numexpr=2.6.4 \
    numpy=1.13.3 \ 
    pandas=0.22.0 \
    peakutils=1.1.1 \
    pillow=5.1.0 \
    psutil=5.4.3 \
    pytables=3.4.2 \
    qtconsole=4.3.1 \
    scikit-allel=1.1.10 \
    scikit-learn=0.19.1 \
    scipy=1.0.1 \
    seaborn=0.8.1 \
    toolz=0.9.0 \
    xlrd=1.1.0 \
    zarr=2.2.0 \
    petl=1.1.1 \
    petlx=1.0.3 \
    openpyxl=2.3.2 \
    sphinx=1.6.5 \
    sphinx-autobuild=0.7.1 \
    datashader \
    distributed=1.21.8 \
    fastparquet \
    ipywidgets \
    jupyterlab=0.32.1 \
    jupyterlab_launcher=0.10.5 \
    holoviews \
    lz4 \
    numba \
    python-blosc \
    scikit-image \
    scikit-learn \
    tornado \
    zict \
    intake-xarray \
    && conda clean -tipsy



RUN pip install cython \
	msgpack \
	xlwt-future \
	prettypandas==0.0.4 \
	scikits.bootstrap==0.3.3 



RUN pip install git+https://github.com/zarr-developers/zarr \
                git+https://github.com/pydata/xarray \
                git+https://github.com/jupyterhub/nbserverproxy \
                git+https://github.com/xgcm/xgcm \
                --no-cache-dir \
                --upgrade


RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \
                                 @jupyterlab/hub-extension \
                                 @pyviz/jupyterlab_pyviz

RUN jupyter serverextension enable --py nbserverproxy --sys-prefix

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /home/$NB_USER/examples && chown -R $NB_USER /home/$NB_USER/examples
RUN mkdir /pre-home && mkdir /pre-home/examples && chown -R $NB_USER /pre-home

RUN mkdir /gcs && chown -R $NB_USER /gcs
RUN mkdir /opt/app

# Add NB_USER to sudo
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
RUN sed -ri "s#Defaults\s+secure_path=\"([^\"]+)\"#Defaults secure_path=\"\1:$CONDA_DIR/bin\"#" /etc/sudoers

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["start.sh jupyter lab"]

