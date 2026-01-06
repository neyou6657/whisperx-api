# 使用Python 3.12 slim镜像（更小）
FROM python:3.12-slim

# 设置环境变量以非交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 安装uv包管理器
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# 设置Python环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    HF_HOME=/data/.cache/huggingface \
    TRANSFORMERS_CACHE=/data/.cache/transformers \
    TORCH_HOME=/data/.cache/torch

# 创建缓存目录
RUN mkdir -p /data/.cache/huggingface /data/.cache/transformers /data/.cache/torch && \
    chmod -R 777 /data && \
    mkdir -p /root/.cache/pip && \
    chmod -R 777 /root/.cache

# 先复制依赖文件以利用Docker缓存
COPY pyproject.toml uv.lock ./

# 使用uv安装依赖（直接从uv.lock安装更可靠）
RUN uv pip install --system --no-cache-dir --no-deps --upgrade pip && \
    (if [ -f uv.lock ]; then \
         echo "Using existing uv.lock file for installation" && \
         uv pip sync uv.lock --system --no-cache-dir --index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple; \
     else \
         echo "uv.lock not found, installing dependencies directly" && \
         uv pip install --system --no-cache-dir --index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple \
             "ffmpeg-python>=0.2.0" "flask>=3.1.2" "openai>=2.7.2" "pydub>=0.25.1" "waitress>=3.0.2" "whisperx>=3.7.4"; \
     fi) || \
    (echo "Falling back to direct installation with official PyPI" && \
     uv pip install --system --no-cache-dir --index-url https://pypi.org/simple \
         "ffmpeg-python>=0.2.0" "flask>=3.1.2" "openai>=2.7.2" "pydub>=0.25.1" "waitress>=3.0.2" "whisperx>=3.7.4")

# 复制项目文件
COPY . .

# 暴露Hugging Face Spaces默认端口
EXPOSE 7860

# 启动应用
CMD ["python", "app.py"]
