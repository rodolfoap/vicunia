#!/bin/bash
cd $(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
python3 download-model.py anon8231489123/vicuna-13b-GPTQ-4bit-128g
