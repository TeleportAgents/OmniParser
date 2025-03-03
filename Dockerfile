FROM nvidia/cuda:12.8.0-base-ubuntu24.04

# Set non-interactive mode to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python3.12 python3.12-venv python3.12-dev python3-pip git \
    wget libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Conda
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p $CONDA_DIR \
    && rm /tmp/miniconda.sh \
    && conda clean --all --yes


RUN conda create -n "omni" python==3.12 
# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "omni", "/bin/bash", "-c"]

RUN pip install --no-cache-dir huggingface_hub fastapi

COPY ./requirements.txt /app/requirements.txt
WORKDIR /app

RUN pip install -r requirements.txt

COPY . /app
RUN python3 -c "from .util.omniparser import Omniparser"

ENTRYPOINT ["run.sh"]


