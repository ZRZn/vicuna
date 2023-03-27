from huggingface_hub import snapshot_download


snapshot_download(repo_id="decapoda-research/llama-7b-hf",
                  local_dir="/root/llm/open_models/llama-7b-hf")