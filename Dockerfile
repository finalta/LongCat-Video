FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-dev \
    python3-pip \
    ffmpeg \
    git \
    wget \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3

RUN pip install --no-cache-dir \
    torch==2.6.0+cu124 \
    torchvision==0.21.0+cu124 \
    torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu124

RUN pip install --no-cache-dir ninja psutil packaging && \
    pip install --no-cache-dir flash_attn==2.7.4.post1 \
    --no-build-isolation

WORKDIR /LongCat-Video

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir \
    numpy==1.26.4 \
    transformers==4.41.0 \
    loguru==0.7.2 \
    diffusers==0.35.1 \
    einops==0.8.0 \
    ftfy==6.2.0 \
    av==12.0.0 \
    opencv-python==4.9.0.80 \
    streamlit==1.50.0 \
    pyarrow==20.0.0 \
    imageio==2.37.0 \
    imageio-ffmpeg==0.6.0 \
    librosa \
    soundfile \
    audio-separator \
    pyloudnorm

RUN pip install --no-cache-dir runpod boto3 "huggingface_hub[hf_transfer,cli]"

COPY . .

RUN chmod +x /LongCat-Video/entrypoint.sh
CMD ["/LongCat-Video/entrypoint.sh"]
