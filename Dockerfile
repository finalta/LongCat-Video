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
    scikit-learn==1.6.1 \
    scikit-image==0.25.2 \
    scipy==1.15.3 \
    soundfile==0.13.1 \
    soxr==0.5.0.post1 \
    librosa==0.11.0 \
    sympy==1.13.1 \
    pyloudnorm==0.1.1 \
    nvidia-ml-py==13.580.65 \
    tzdata==2025.2 \
    onnx==1.18.0 \
    onnxruntime==1.16.3 \
    openai==1.75.0 \
    cffi==2.0.0 \
    chardet==5.2.0 \
    audio-separator==0.30.2

RUN pip install --no-cache-dir runpod boto3 "huggingface_hub[hf_transfer,cli]"

COPY . .

RUN chmod +x /LongCat-Video/entrypoint.sh
CMD ["/LongCat-Video/entrypoint.sh"]
