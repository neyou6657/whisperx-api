# 🚀 快速部署到 Hugging Face Spaces

这是一个简化的部署指南，帮助你快速将项目部署到 Hugging Face 免费的 CPU Spaces。

## 📦 所需文件

项目已经包含了所有必需的部署文件：
- ✅ `Dockerfile` - Docker 镜像配置
- ✅ `app.py` - 主应用（已适配 Hugging Face Spaces）
- ✅ `pyproject.toml` - Python 依赖
- ✅ `uv.lock` - 依赖锁定文件
- ✅ `index.html` - Web 界面

## 🎯 5分钟部署步骤

### 1. 创建 Hugging Face Space

1. 访问 [huggingface.co](https://huggingface.co/) 并登录
2. 点击右上角 `+ New` → `New Space`
3. 填写信息：
   - **Space name**: 例如 `whisperx-api`（可自定义）
   - **SDK**: 选择 `Docker`
   - **Hardware**: 选择 `CPU basic`（免费）
4. 点击 `Create Space`

### 2. 上传代码

**方法 A：使用 Git（推荐）**

```bash
# 克隆你的 Space 仓库
git clone https://huggingface.co/spaces/你的用户名/whisperx-api
cd whisperx-api

# 复制项目文件到此目录
# （将 app.py, index.html, Dockerfile, pyproject.toml, uv.lock, HF_SPACE_README.md 复制到这里）

# 提交并推送
git add .
git commit -m "Initial commit"
git push
```

**方法 B：Web 界面上传**

1. 进入你的 Space 页面
2. 点击 `Files` → `Add file` → `Upload files`
3. 逐个上传以下文件：
   - `Dockerfile`
   - `app.py`
   - `pyproject.toml`
   - `uv.lock`
   - `index.html`
   - `HF_SPACE_README.md`

### 3. 等待构建

- Hugging Face 会自动构建 Docker 镜像
- 首次构建需要 5-15 分钟（下载依赖）
- 在 Space 页面可以看到构建状态

### 4. 使用服务

构建完成后，访问你的 Space URL（如 `https://你的用户名-whisperx-api.hf.space`）

- **Web 界面**: 直接使用拖拽上传音频
- **API**: 使用 OpenAI 客户端调用

## 🔧 可选：启用说话人分离

如果需要说话人识别功能：

1. 在 Hugging Face 上接受模型协议：
   - [pyannote/speaker-diarization-3.1](https://huggingface.co/pyannote/speaker-diarization-3.1)
   - [pyannote/segmentation-3.0](https://huggingface.co/pyannote/segmentation-3.0)

2. 获取 Token：
   - 访问 [Settings > Tokens](https://huggingface.co/settings/tokens)
   - 创建 `read` 权限的 Token

3. 在 Space 中设置环境变量：
   - 进入你的 Space → `Settings`
   - 找到 `Variables and secrets`
   - 添加：
     - **Name**: `HUGGING_FACE_TOKEN`
     - **Value**: 你的 Token

## 📊 性能说明

- **免费 CPU**: 处理速度较慢，但完全可用
- **推荐模型**: `small` 或 `medium`（默认已设为 `small`）
- **首启动**: 首次使用某模型需下载，约 1-10 分钟
- **音频长度**: 建议 < 30 分钟（避免超时）

## ❓ 常见问题

**Q: 构建失败怎么办？**
A: 检查 Space 的 Logs 标签页，查看具体错误信息

**Q: 很慢，如何加速？**
A: 这是免费 CPU 的正常现象。可以考虑：
- 使用更小的模型（tiny/base）
- 升级到付费的 CPU upgrade（$0.15/小时）
- 本地部署（使用 GPU）

**Q: Space 休眠了怎么办？**
A: 免费 Space 会在无活动时休眠，重新访问即可唤醒（约 1-2 分钟）

## 📚 完整文档

查看 [DEPLOY_TO_HF.md](DEPLOY_TO_HF.md) 了解更多详细信息。
