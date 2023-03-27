BASE_MODEL="/root/llm/open_models/llama-7b-hf"
# LORA_PATH="/root/llm/vicuna/lora-Vicuna/checkpoint-8000"
LORA_PATH="/root/llm/vicuna/zrz_models/checkpoint-600"
cp /root/llm/vicuna/config-sample/adapter_config.json $LORA_PATH
CUDA_VISIBLE_DEVICES=1 python generate.py \
    --model_path $BASE_MODEL \
    --lora_path $LORA_PATH
