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

COPY requirements_avatar.txt .
RUN grep -v "torch\|flash.attn\|flash_attn" requirements_avatar.txt > requirements_avatar_filtered.txt && \
    pip install --no-cache-dir -r requirements_avatar_filtered.txt

RUN pip install --no-cache-dir runpod boto3 "huggingface_hub[hf_transfer,cli]"

COPY . .

RUN chmod +x /LongCat-Video/entrypoint.sh

CMD ["/LongCat-Video/entrypoint.sh"]
