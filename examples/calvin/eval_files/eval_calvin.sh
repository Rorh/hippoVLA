#!/bin/bash
set -euo pipefail

REPO_ROOT=/home/rorschach/github_projects/vla/starVLA_code
cd "${REPO_ROOT}"

export PYTHONPATH="${REPO_ROOT}:${PYTHONPATH:-}"

CALVIN_PYTHON=${CALVIN_PYTHON:-python}
HOST=${HOST:-127.0.0.1}
PORT=${PORT:-5694}
UNNORM_KEY=${UNNORM_KEY:-franka}
CKPT_PATH=${CKPT_PATH:-/home/rorschach/github_projects/vla/ckpt/pytorch_model.pt}
CALVIN_DATASET_PATH=${CALVIN_DATASET_PATH:-/mnt/data/jiangnan/calvin/task_D_D}
CALVIN_CONFIG_PATH=${CALVIN_CONFIG_PATH:-/mnt/data/jiangnan/calvin/calvin/calvin_models/conf}
EVAL_SEQUENCES_PATH=${EVAL_SEQUENCES_PATH:-${REPO_ROOT}/examples/calvin/eval_files/eval_sequences.json}
NUM_SEQUENCES=${NUM_SEQUENCES:-1000}
EVAL_LOG_DIR=${EVAL_LOG_DIR:-logs/calvin/$(date +"%Y%m%d_%H%M%S")}

if [ ! -f "${CKPT_PATH}" ]; then
    echo "Checkpoint not found: ${CKPT_PATH}" >&2
    exit 1
fi

if [ ! -d "${CALVIN_DATASET_PATH}/validation" ]; then
    echo "CALVIN validation directory not found: ${CALVIN_DATASET_PATH}/validation" >&2
    exit 1
fi

if [ ! -d "${CALVIN_CONFIG_PATH}" ]; then
    echo "CALVIN config directory not found: ${CALVIN_CONFIG_PATH}" >&2
    exit 1
fi

if [ ! -f "${EVAL_SEQUENCES_PATH}" ]; then
    echo "Eval sequences file not found: ${EVAL_SEQUENCES_PATH}" >&2
    exit 1
fi

mkdir -p "${EVAL_LOG_DIR}"

"${CALVIN_PYTHON}" ./examples/calvin/eval_files/eval_calvin.py \
    --args.pretrained-path "${CKPT_PATH}" \
    --args.unnorm-key "${UNNORM_KEY}" \
    --args.host "${HOST}" \
    --args.port "${PORT}" \
    --args.dataset_path "${CALVIN_DATASET_PATH}" \
    --args.calvin_config_path "${CALVIN_CONFIG_PATH}" \
    --args.eval_sequences_path "${EVAL_SEQUENCES_PATH}" \
    --args.num_sequences "${NUM_SEQUENCES}" \
    --args.eval_log_dir "${EVAL_LOG_DIR}"
