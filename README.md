# hippoVLA Environment Setup and CALVIN Evaluation

This README only covers environment setup and CALVIN evaluation.
Run commands from the repository root:

```bash
cd /home/user/path/to/hippoVLA```

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

The current checkpoint path is:

```bash
export CKPT_PATH=/home/rorschach/github_projects/vla/ckpt/pytorch_model.pt
```

Set these paths before evaluation if your CALVIN data is mounted elsewhere:

```bash
export CALVIN_DATASET_PATH=/mnt/data/jiangnan/calvin/task_D_D
export CALVIN_CONFIG_PATH=/mnt/data/jiangnan/calvin/calvin/calvin_models/conf
export EVAL_SEQUENCES_PATH=/home/rorschach/path/to/hippoVLA/examples/calvin/eval_files/eval_sequences.json
```

`CALVIN_DATASET_PATH` should contain the `validation/` directory. `CALVIN_CONFIG_PATH`
should point to the CALVIN `calvin_models/conf` directory.

## 3. Start Policy Server

Terminal 1:

```bash
cd /home/user/path/to/hippoVLA
conda activate hippoVLA

CKPT_PATH=/home/rorschach/github_projects/vla/ckpt/pytorch_model.pt \
GPU_ID=0 \
PORT=5694 \
bash examples/calvin/eval_files/run_policy_server.sh
```

## 4. Run CALVIN Evaluation

Terminal 2, inside your CALVIN environment:

```bash
cd /home/user/path/to/hippoVLA

CKPT_PATH=/home/rorschach/github_projects/vla/ckpt/pytorch_model.pt \
CALVIN_DATASET_PATH=/mnt/data/jiangnan/calvin/task_D_D \
CALVIN_CONFIG_PATH=/mnt/data/jiangnan/calvin/calvin/calvin_models/conf \
EVAL_SEQUENCES_PATH=/home/user/path/to/hippoVLA/examples/calvin/eval_files/eval_sequences.json \
HOST=127.0.0.1 \
PORT=5694 \
NUM_SEQUENCES=1000 \
bash examples/calvin/eval_files/eval_calvin.sh
```

If the CALVIN evaluator is not available in the active shell, pass its Python
binary explicitly after activating the CALVIN environment:

```bash
CALVIN_PYTHON=$(which python) bash examples/calvin/eval_files/eval_calvin.sh
```
