FROM rednotehilab/dots.ocr:vllm-openai-v0.9.1

RUN git clone https://github.com/rednote-hilab/dots.ocr.git
RUN uv pip install huggingface_hub --system
RUN cd ./dots.ocr && uv run tools/download_model.py

WORKDIR /vllm-workspace/dots.ocr/weights

ENV hf_model_path=/vllm-workspace/dots.ocr/weights/DotsOCR
ENV PYTHONPATH=/vllm-workspace/dots.ocr/weights

RUN sed -i '/^from vllm.entrypoints.cli.main import main$/a\
from DotsOCR import modeling_dots_ocr_vllm\nprint("DotsOCR import 성공!")' $(which vllm)
RUN sed -i '/^from vllm.entrypoints.cli.main import main$/a\
from DotsOCR.modeling_dots_ocr_vllm import DotsOCRForCausalLM\nprint("DotsOCRForCausalLM import 성공!")' $(which vllm)

