#!/bin/bash
set -euo pipefail

REPO_ROOT=/home/rorschach/github_projects/vla/starVLA_code
cd "${REPO_ROOT}"

export PYTHONPATH="${REPO_ROOT}:${PYTHONPATH:-}"

STAR_VLA_PYTHON=${STAR_VLA_PYTHON:-/home/rorschach/anaconda3/envs/starVLA/bin/python}
CKPT_PATH=${CKPT_PATH:-/home/rorschach/github_projects/vla/ckpt/pytorch_model.pt}
GPU_ID=${GPU_ID:-0}
PORT=${PORT:-5694}

if [ ! -x "${STAR_VLA_PYTHON}" ]; then
    echo "STAR_VLA_PYTHON is not executable: ${STAR_VLA_PYTHON}" >&2
    exit 1
fi

if [ ! -f "${CKPT_PATH}" ]; then
    echo "Checkpoint not found: ${CKPT_PATH}" >&2
    exit 1
fi

CUDA_VISIBLE_DEVICES="${GPU_ID}" "${STAR_VLA_PYTHON}" deployment/model_server/server_policy.py \
    --ckpt_path "${CKPT_PATH}" \
    --port "${PORT}" \
    --use_bf16
