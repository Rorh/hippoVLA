## Use the convert_to_lerobot_starvla.py to transform dataset

## run calvin benchmark
cd /home/user01/jiangnan/starVLA
conda activate starVLA
export PYTHONPATH=$(pwd):${PYTHONPATH}
CUDA_VISIBLE_DEVICES=1 python deployment/model_server/server_policy.py \
  --ckpt_path /home/user01/jiangnan/starVLA/results/Checkpoints/starvla_rynnbrain_calvin_task_ABC_D_memory_dit_inter5_step5/final_model/pytorch_model.pt \
  --port 5695 \
  --use_bf16

## another terminal
cd /home/user01/jiangnan/starVLA
conda activate calvin310
export PYTHONPATH=$(pwd):${PYTHONPATH}
python examples/calvin/eval_files/eval_calvin.py \
  --args.pretrained-path /home/user01/jiangnan/starVLA/results/Checkpoints/starvla_rynnbrain_calvin_task_ABC_D_memory_dit_inter5_step5/final_model/pytorch_model.pt \
  --args.unnorm-key franka \
  --args.host 127.0.0.1 \
  --args.port 5695 \
  --args.dataset_path /mnt/data/jiangnan/calvin/task_D_D \
  --args.calvin_config_path /mnt/data/jiangnan/calvin/calvin/calvin_models/conf \
  --args.eval_sequences_path /home/user01/jiangnan/starVLA/examples/calvin/eval_files/eval_sequences.json \
  --args.num_sequences 1000