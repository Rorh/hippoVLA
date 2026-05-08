# CALVIN Evaluation

This folder documents CALVIN evaluation only. Training and dataset conversion are
not required for the evaluation flow below.

## Paths

The evaluation scripts use these defaults:

```bash
REPO_ROOT=/home/rorschach/github_projects/vla/starVLA_code
CKPT_PATH=/home/rorschach/github_projects/vla/ckpt/pytorch_model.pt
CALVIN_DATASET_PATH=/mnt/data/jiangnan/calvin/task_D_D
CALVIN_CONFIG_PATH=/mnt/data/jiangnan/calvin/calvin/calvin_models/conf
EVAL_SEQUENCES_PATH=/home/rorschach/github_projects/vla/starVLA_code/examples/calvin/eval_files/eval_sequences.json
PORT=5694
```

`CALVIN_DATASET_PATH` must contain `validation/`. If your CALVIN dataset is
mounted in a different location, override `CALVIN_DATASET_PATH` and
`CALVIN_CONFIG_PATH` when launching evaluation.

## Terminal 1: Policy Server

Run this from the StarVLA environment:

```bash
cd /home/rorschach/github_projects/vla/starVLA_code
conda activate starVLA

bash examples/calvin/eval_files/run_policy_server.sh
```

## Terminal 2: CALVIN Evaluation

Run this from the CALVIN environment:

```bash
cd /home/rorschach/github_projects/vla/starVLA_code

CALVIN_PYTHON=$(which python) \
bash examples/calvin/eval_files/eval_calvin.sh
```

To override the data paths:

```bash
CALVIN_DATASET_PATH=/mnt/data/jiangnan/calvin/task_D_D \
CALVIN_CONFIG_PATH=/mnt/data/jiangnan/calvin/calvin/calvin_models/conf \
CALVIN_PYTHON=$(which python) \
bash examples/calvin/eval_files/eval_calvin.sh
```
