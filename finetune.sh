TOT_CUDA="0,1"
CUDAs=(${TOT_CUDA//,/ })
CUDA_NUM=${#CUDAs[@]}
PORT="1234"

DATA_PATH="/root/llm/open_datas/merge2.json"
OUTPUT_PATH="zrz_models"
MODEL_PATH="/root/llm/open_models/llama-7b-hf"

CUDA_VISIBLE_DEVICES=${TOT_CUDA} torchrun --nproc_per_node=$CUDA_NUM --master_port=$PORT finetune.py \
--data_path $DATA_PATH \
--output_path $OUTPUT_PATH \
--model_path $MODEL_PATH \
--eval_steps 200 \
--save_steps 200 \
--test_size 1