# Hugging Face Spaces 部署指南

本指南介绍如何将此项目部署到 Hugging Face Spaces（免费CPU资源）。

## 📋 部署步骤

### 1. 准备Hugging Face账户

- 访问 [huggingface.co](https://huggingface.co/) 并注册/登录账户
- 如果需要说话人分离功能，需要：
  - 访问 [pyannote/speaker-diarization-3.1](https://huggingface.co/pyannote/speaker-diarization-3.1) 并接受用户协议
  - 访问 [pyannote/segmentation-3.0](https://huggingface.co/pyannote/segmentation-3.0) 并接受用户协议

### 2. 创建Space

1. 点击 Hugging Face 网站右上角的 `+ New` 按钮
2. 选择 `New Space`
3. 填写配置：
   - **Owner**: 你的用户名
   - **Space name**: 随意填写（如 `whisperx-api`）
   - **Select the Space SDK**: 选择 `Docker`
   - **Space hardware**: 选择 `CPU basic`（免费）或 `CPU upgrade`（付费，更快）
   - **Make it public**: 可选，公开可以免费使用，私有需要付费

### 3. 上传代码

将以下文件上传到你的Space仓库：
- `Dockerfile` （已包含）
- `app.py`
- `pyproject.toml`
- `uv.lock`
- `index.html`
- `README.md`

可以通过以下方式上传：

**方式A：通过Git上传**
```bash
git clone https://huggingface.co/spaces/你的用户名/你的space名称
cd 你的space名称

# 复制所有项目文件到此目录

git add .
git commit -m "Initial commit"
git push
```

**方式B：通过Web界面上传**
- 在Space页面点击 `Files` 标签
- 点击 `Add file` → `Upload files`
- 逐个上传文件

### 4. 配置环境变量（可选）

如果你使用说话人分离功能，需要在Space设置中添加环境变量：

1. 进入你的Space页面
2. 点击 `Settings` 标签
3. 找到 `Variables and secrets` 部分
4. 点击 `New variable`
5. 添加：
   - **Name**: `HUGGING_FACE_TOKEN`
   - **Value**: 你的Hugging Face访问令牌（read权限）

获取Token方法：
- 访问 [Hugging Face Tokens 页面](https://huggingface.co/settings/tokens)
- 创建一个新的 `read` 权限的访问令牌

### 5. 部署

代码上传后，Hugging Face会自动开始构建Docker镜像并部署。

- 在Space页面可以看到构建进度
- 首次部署需要下载模型，可能需要10-30分钟（取决于模型大小和网络）
- 构建完成后，Space会自动启动
- 在Space页面可以看到访问URL（如 `https://your-space.hf.space`）

## 📝 使用说明

### 通过Web界面使用

1. 访问你的Space URL
2. 拖拽或点击上传音频/视频文件
3. 选择语言、模型和参数
4. 点击"提交转录"等待结果

### 通过API使用

API端点：`https://your-space.hf.space/v1/audio/transcriptions`

```python
from openai import OpenAI

# 使用你的Space URL
client = OpenAI(
    base_url='https://your-space.hf.space/v1',
    api_key='dummy-key'  # 可以是任意值
)

audio_path = "path/to/your/audio.wav"

with open(audio_path, "rb") as audio_file:
    transcript = client.audio.transcriptions.create(
        model="large-v3",
        file=audio_file,
        response_format="diarized_json",
        extra_body={
            "max_speakers": 0,  # 0=启用说话人分离
            "min_speakers": 0
        },
    )

for segment in transcript.segments:
    speaker = segment.get('speaker', 'Unknown')
    start_time = segment['start']
    end_time = segment['end']
    text = segment['text']
    print(f"[{start_time:.2f}s -> {end_time:.2f}s] {speaker}: {text}")
```

## ⚠️ 注意事项

### 性能限制

- **免费CPU资源**: 免费的CPU basic资源有限，处理速度会比较慢
- **模型大小**: 首次部署时，Hugging Face会下载WhisperX模型
  - `tiny`: ~40MB，最快
  - `base`: ~140MB
  - `small`: ~460MB
  - `medium`: ~1.5GB
  - `large-v3`: ~3GB，最慢但最准确
- **推荐配置**: 在CPU环境中建议使用 `small` 或 `medium` 模型，平衡速度和准确度

### 睡眠机制

- Hugging Face免费Space会在没有活动时自动"睡眠"
- 下次访问需要等待几秒钟"唤醒"时间
- 可以通过定期ping保持活跃（不推荐，可能违反使用条款）

### 存储空间

- Spaces有存储空间限制（约20GB）
- 临时文件会自动清理
- 不要存储大量静态文件

### 超时设置

- CPU spaces有执行时间限制（通常几小时）
- 长音频（>1小时）可能会超时
- 建议分段处理长音频

## 🚀 优化建议

### 加速模型加载

首次启动时，模型会自动下载并缓存。后续启动会使用缓存，速度更快。

### 选择合适的模型

在CPU环境中：
- **快速处理**: `tiny`, `base`
- **平衡**: `small`, `medium`
- **最佳质量**: `large-v3`（但很慢）

### 批量处理

如果需要处理多个文件，可以：
1. 上传到一个文件
2. 分别提交处理请求
3. 等待结果

## 🐛 故障排除

### 构建失败

- 检查 `Dockerfile` 是否正确
- 查看构建日志中的错误信息
- 确保所有依赖都在 `pyproject.toml` 中

### 服务启动失败

- 查看 Space 的 `Logs` 标签页
- 检查 FFmpeg 是否正确安装（Dockerfile中已包含）
- 确认端口配置正确（默认7860）

### 处理速度慢

- 这是正常现象，免费CPU资源有限
- 考虑升级到付费的CPU upgrade
- 或者使用更小的模型

### 内存不足

- 避免同时上传多个大文件
- 等待前一个任务完成再提交新任务

## 📊 资源使用监控

在Space页面可以查看：
- CPU使用率
- 内存使用情况
- 磁盘使用情况
- 访问日志

## 🔒 安全建议

- 不要在代码中硬编码敏感信息
- 使用环境变量存储Token
- 公开Space的所有代码和数据都是可见的
- 如需保护隐私，使用私有Space（需要付费）

## 💡 成本

**免费方案**:
- CPU basic: 免费
- 存储: 约20GB免费
- 注意：有使用限制和睡眠机制

**付费方案**:
- CPU upgrade: ~$0.15/小时
- 存储: ~$0.10/GB/月
- 无睡眠限制，更快

## 📞 支持

遇到问题时：
1. 查看Space的Logs
2. 检查Hugging Face文档
3. 在原项目GitHub提Issue
