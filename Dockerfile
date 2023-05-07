FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y git vim build-essential python3-dev python3-venv python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

WORKDIR /
RUN pip3 install --upgrade pip setuptools
RUN pip3 install torch torchvision torchaudio
COPY requirements.txt .
RUN pip3 install -r requirements.txt && rm requirements.txt

RUN git clone https://github.com/thisserand/FastChat.git /fastchat
RUN cd /fastchat && python3 -m pip install -e .

RUN mkdir -p /fastchat/repositories/
RUN git clone https://github.com/oobabooga/GPTQ-for-LLaMa /fastchat/repositories/GPTQ-for-LLaMa
ARG TORCH_CUDA_ARCH_LIST=7.5
ARG WEBUI_VERSION=HEAD
RUN cd /fastchat/repositories/GPTQ-for-LLaMa && python3 setup_cuda.py bdist_wheel -d .
RUN rm /usr/local/cuda

# -----------------------------------------------------------------------------------------------------------------------
WORKDIR /fastchat
COPY gpu_test.py .
CMD python3 -m venv /venv && python3 -m fastchat.serve.cli --model-name anon8231489123/vicuna-13b-GPTQ-4bit-128g --wbits 4 --groupsize 128
