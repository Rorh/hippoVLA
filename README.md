# hippoVLA Environment Setup and CALVIN Evaluation

This README only covers environment setup and CALVIN evaluation.
Run commands from the repository root:

```bash
cd /path/to/hippoVLA
```

## 1. Install hippoVLA Environment

```bash
conda create -n hippoVLA python=3.10 -y
conda activate hippoVLA

python -m pip install --upgrade pip setuptools wheel

pip install -r requirements.txt
pip install ./transformer
pip install flash-attn --no-build-isolation
pip install -e .
```

`flash-attn` must match the local CUDA and PyTorch versions. If installation fails,
check:

```bash
nvcc -V
python -m pip list | grep -E 'torch|flash-attn|transformers'
```

## 2. Prepare CALVIN Evaluation Paths

Evaluation uses two Python environments:

- `hippoVLA`: starts the hippoVLA policy server.
- CALVIN environment: runs the CALVIN simulator and evaluator.

Download the checkpoint package from Hugging Face:

```text
https://huggingface.co/rorschachkelvin/RynnBrain_memory
```

Place or keep the downloaded files under:

```bash
/path/to/ckpt
```

The expected checkpoint layout is:

```text
/path/to/ckpt
├── calvin/calvin_models/conf
└── hippoVLA_rynnbrain_calvin_task_ABC_D_memory_dit_inter10_step5
    ├── config.yaml
    ├── dataset_statistics.json
    └── final_model/pytorch_model.pt
```

Use these model and CALVIN config paths:

```bash
export CKPT_ROOT=/path/to/ckpt
export MODEL_DIR=${CKPT_ROOT}/hippoVLA_rynnbrain_calvin_task_ABC_D_memory_dit_inter10_step5
export CKPT_PATH=${MODEL_DIR}/final_model/pytorch_model.pt
export MODEL_CONFIG_PATH=${MODEL_DIR}/config.yaml
export DATASET_STATISTICS_PATH=${MODEL_DIR}/dataset_statistics.json
export CALVIN_CONFIG_PATH=${CKPT_ROOT}/calvin/calvin_models/conf
```

Set these paths before evaluation. If your CALVIN dataset is mounted elsewhere,
only change `CALVIN_DATASET_PATH`:

```bash
export CALVIN_DATASET_PATH=/path/to/calvin/task_D_D
export EVAL_SEQUENCES_PATH=/path/to/hippoVLA/examples/calvin/eval_files/eval_sequences.json
```

`CALVIN_DATASET_PATH` should contain the `validation/` directory. `CALVIN_CONFIG_PATH`
should point to the CALVIN `calvin_models/conf` directory included in the
checkpoint package.

## 3. Start Policy Server

Terminal 1:

```bash
cd /path/to/hippoVLA
conda activate hippoVLA

CKPT_PATH=/path/to/ckpt/hippoVLA_rynnbrain_calvin_task_ABC_D_memory_dit_inter10_step5/final_model/pytorch_model.pt \
GPU_ID=0 \
PORT=5694 \
bash examples/calvin/eval_files/run_policy_server.sh
```

## 4. Run CALVIN Evaluation

Terminal 2, inside your CALVIN environment:

```bash
cd /path/to/hippoVLA

CKPT_PATH=/path/to/ckpt/hippoVLA_rynnbrain_calvin_task_ABC_D_memory_dit_inter10_step5/final_model/pytorch_model.pt \
CALVIN_DATASET_PATH=/path/to/calvin/task_D_D \
CALVIN_CONFIG_PATH=/path/to/ckpt/calvin/calvin_models/conf \
EVAL_SEQUENCES_PATH=/path/to/hippoVLA/examples/calvin/eval_files/eval_sequences.json \
HOST=127.0.0.1 \
PORT=5694 \
NUM_SEQUENCES=1000 \
bash examples/calvin/eval_files/eval_calvin.sh
```
