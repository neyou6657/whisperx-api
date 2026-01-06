# Hugging Face Spaces 部署更改说明

本文档列出了为支持 Hugging Face Spaces 部署所做的所有更改。

## 📋 新增文件

### 1. Dockerfile
Hugging Face Spaces 的 Docker 镜像配置文件。

**特性：**
- 使用 Python 3.12 slim 基础镜像（更小）
- 安装 FFmpeg 等系统依赖
- 使用 uv 包管理器安装 Python 依赖
- 配置 Hugging Face 缓存目录
- 暴露 7860 端口（Hugging Face Spaces 默认端口）

### 2. DEPLOY_TO_HF.md
详细的 Hugging Face Spaces 部署指南。

**内容包括：**
- 完整的部署步骤说明
- 环境变量配置指南
- 使用说明（Web 界面和 API）
- 性能优化建议
- 故障排除指南
- 成本说明

### 3. HF_SPACE_README.md
Hugging Face Space 页面显示的 README 文件。

**特性：**
- 包含 Space 元数据（emoji、颜色等）
- 简洁的使用说明
- API 调用示例
- 注意事项和模型选择建议

### 4. QUICK_START_HF.md
简化的快速开始指南（5分钟部署）。

**内容包括：**
- 5 分钟快速部署步骤
- Git 和 Web 两种上传方式
- 可选的说话人分离配置
- 常见问题解答

### 5. .dockerignore
Docker 构建时忽略的文件列表。

**作用：**
- 减小 Docker 镜像大小
- 避免上传不必要的文件（如 .git、缓存等）

### 6. .spaceignore
Hugging Face Spaces 忽略的文件列表（类似 .gitignore）。

## 🔧 修改的文件

### 1. app.py

#### 修改 1：自动检测 Hugging Face Spaces 环境
```python
# 在 if __name__ == '__main__' 部分
if os.environ.get('SPACE_ID'):
    host = '0.0.0.0'
    port = int(os.environ.get('PORT', 7860))
    logging.info(f"检测到 Hugging Face Spaces 环境")
else:
    host = '127.0.0.1'
    port = 9092
    url = f"http://{host}:{port}"
    Timer(1, lambda: open_browser(url)).start()
```

**作用：**
- 在 Spaces 环境中使用 `0.0.0.0` 监听所有网络接口
- 使用环境变量 `PORT` 或默认的 7860 端口
- 在本地环境保持原有行为（自动打开浏览器）

#### 修改 2：调整批处理大小
```python
# 在设备和计算类型配置部分
BATCH_SIZE = 4 if os.environ.get('SPACE_ID') else 16
```

**作用：**
- 在 Spaces CPU 环境中使用更小的批处理大小（4）
- 避免内存溢出
- 在本地环境保持原有性能（16）

#### 修改 3：调整默认模型
```python
# 在模型配置部分
DEFAULT_MODEL = 'small' if os.environ.get('SPACE_ID') else 'large-v3'
```

**作用：**
- 在 Spaces 环境中使用 `small` 模型作为默认值
- 平衡速度和准确度，更适合 CPU 环境
- 在本地环境保持高质量默认值（large-v3）

### 2. README.md

#### 修改：添加云端部署亮点
在"项目亮点"部分添加：
- ☁️ **云端部署**: 支持部署到 Hugging Face Spaces（免费CPU资源）。

#### 修改：添加部署链接
在 README 末尾添加新章节：
```markdown
## ☁️ 部署到 Hugging Face Spaces

想将此项目部署到云端？查看 [**Hugging Face Spaces 部署指南**](DEPLOY_TO_HF.md)，了解如何使用免费CPU资源部署。
```

## 📦 部署文件清单

上传到 Hugging Face Spaces 所需的文件：

### 必需文件
- ✅ `Dockerfile` - Docker 配置
- ✅ `app.py` - 主应用（已修改）
- ✅ `pyproject.toml` - Python 依赖定义
- ✅ `uv.lock` - 依赖锁定文件
- ✅ `index.html` - Web 界面
- ✅ `HF_SPACE_README.md` - Space 页面显示的 README

### 可选文件
- 📄 `README.md` - 项目说明（可覆盖 HF_SPACE_README.md）
- 📄 `.dockerignore` - Docker 构建忽略文件
- 📄 `.spaceignore` - Space 忽略文件

## 🚀 快速部署命令

```bash
# 1. 克隆你的 Space 仓库
git clone https://huggingface.co/spaces/你的用户名/你的space名称
cd 你的space名称

# 2. 复制必需文件
cp /path/to/project/Dockerfile .
cp /path/to/project/app.py .
cp /path/to/project/pyproject.toml .
cp /path/to/project/uv.lock .
cp /path/to/project/index.html .
cp /path/to/project/HF_SPACE_README.md README.md

# 3. 提交并推送
git add .
git commit -m "Deploy WhisperX API to Hugging Face Spaces"
git push
```

## ⚙️ 环境变量配置

在 Hugging Face Space 设置中可以配置以下环境变量：

### 必需
- `PORT` (可选): 服务端口，默认 7860

### 可选
- `HUGGING_FACE_TOKEN`: 用于说话人分离功能的 Hugging Face 访问令牌

获取 Token 方法：
1. 访问 https://huggingface.co/settings/tokens
2. 创建新的 `read` 权限令牌
3. 在 Space 的 Settings > Variables and secrets 中添加

## 📊 性能优化说明

### Spaces 环境优化
1. **默认模型**: `small`（平衡速度和准确度）
2. **批处理大小**: 4（避免内存溢出）
3. **计算类型**: `int8`（CPU 优化）

### 本地环境（未改变）
1. **默认模型**: `large-v3`（最高准确度）
2. **批处理大小**: 16（最大吞吐量）
3. **计算类型**: `float16`（GPU）或 `int8`（CPU）

## 🎯 部署后测试

部署完成后，可以通过以下方式测试：

### 1. Web 界面
访问你的 Space URL，上传音频文件测试转录功能。

### 2. API 测试
```bash
curl -X POST "https://你的space.hf.space/v1/audio/transcriptions" \
  -H "Authorization: Bearer dummy" \
  -F "file=@test.wav" \
  -F "model=small" \
  -F "response_format=diarized_json"
```

## 📝 注意事项

1. **首次构建**: 首次部署需要 5-15 分钟构建 Docker 镜像
2. **模型下载**: 首次使用某个模型需要 1-10 分钟下载
3. **处理速度**: 免费资源处理速度较慢，这是正常的
4. **休眠机制**: 免费 Space 在无活动时会休眠
5. **超时限制**: 长音频文件（>30分钟）可能超时

## 🔍 故障排除

### 构建失败
- 查看 Space 的 Logs 标签页
- 检查 Dockerfile 语法
- 确认所有依赖都在 pyproject.toml 中

### 服务启动失败
- 检查端口配置（7860）
- 查看 FFmpeg 是否正确安装
- 确认环境变量配置正确

### 处理速度慢
- 这是免费 CPU 的正常现象
- 可以升级到付费的 CPU upgrade
- 或使用更小的模型（tiny/base）

## 📚 相关文档

- [DEPLOY_TO_HF.md](DEPLOY_TO_HF.md) - 完整部署指南
- [QUICK_START_HF.md](QUICK_START_HF.md) - 快速开始指南
- [README.md](README.md) - 项目总览
