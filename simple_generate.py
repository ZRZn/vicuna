import sys
import torch
from peft import PeftModel
import transformers
from transformers import LlamaTokenizer, LlamaForCausalLM

model_path = "/root/llm/open_models/llama-7b-hf"
tokenizer = LlamaTokenizer.from_pretrained(model_path)
BASE_MODEL = model_path

model = LlamaForCausalLM.from_pretrained(
    BASE_MODEL,
    load_in_8bit=True,
    torch_dtype=torch.float16,
    device_map="auto",
)
model.eval()
inputs = "中国的首都在哪里？" #"你好,美国的首都在哪里？"
input_ids = tokenizer(inputs, return_tensors="pt")['input_ids']
print(input_ids)
generation_output = model.generate(
            input_ids=input_ids,
            max_new_tokens=35,
        )
print(generation_output)
print(tokenizer.decode(generation_output[0]))

model = PeftModel.from_pretrained(
        model,
        "/root/llm/vicuna/zrz_models/checkpoint-600",
        torch_dtype=torch.float16,
        device_map={'': 0}
    )

inputs = "你好,中国的首都在哪里？" #"你好,美国的首都在哪里？"
# inputs = "我今天心情不太好，怎么办呢？"
input_ids = tokenizer(inputs, return_tensors="pt")['input_ids']
print(input_ids)
generation_output = model.generate(
            input_ids=input_ids,
            max_new_tokens=35,
        )
print("generation_output = ", generation_output)
print("final out = ", tokenizer.decode(generation_output[0]))
