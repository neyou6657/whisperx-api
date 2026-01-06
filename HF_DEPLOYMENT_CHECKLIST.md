# Hugging Face Spaces 部署检查清单

使用此检查清单确保你的 WhisperX API 成功部署到 Hugging Face Spaces。

## 📋 部署前检查

- [ ] 已注册 Hugging Face 账户
- [ ] 已创建一个新的 Space（SDK 选择 Docker）
- [ ] Space 硬件选择：CPU basic（免费）

## 📦 文件准备

### 必需文件（必须上传）
- [ ] `Dockerfile` - Docker 镜像配置
- [ ] `app.py` - 主应用代码（已修改以支持 Spaces）
- [ ] `pyproject.toml` - Python 依赖定义
- [ ] `uv.lock` - 依赖锁定文件
- [ ] `index.html` - Web 界面
- [ ] `README.md` - 使用 `HF_SPACE_README.md` 的内容

### 可选文件
- [ ] `.dockerignore` - Docker 构建忽略文件
- [ ] `.spaceignore` - Space 忽略文件

## 🔧 配置检查

### 环境变量（可选）
如需说话人分离功能：
- [ ] 已访问并接受 [pyannote/speaker-diarization-3.1](https://huggingface.co/pyannote/speaker-diarization-3.1) 协议
- [ ] 已访问并接受 [pyannote/segmentation-3.0](https://huggingface.co/pyannote/segmentation-3.0) 协议
- [ ] 已在 [Hugging Face Tokens](https://huggingface.co/settings/tokens) 创建 Token
- [ ] 已在 Space Settings > Variables 中添加 `HUGGING_FACE_TOKEN`

## 🚀 部署步骤

### 1. 上传文件（选择一种方式）

#### 方式 A：Git
```bash
git clone https://huggingface.co/spaces/你的用户名/你的space名称
cd 你的space名称

# 复制所有必需文件到此目录

git add .
git commit -m "Deploy WhisperX API"
git push
```

#### 方式 B：Web 界面
- [ ] 进入 Space 的 Files 标签
- [ ] 点击 Add file > Upload files
- [ ] 逐个上传所有必需文件

### 2. 等待构建
- [ ] Space 开始自动构建
- [ ] 查看构建日志确认无错误
- [ ] 等待构建完成（首次约 5-15 分钟）

### 3. 验证部署
- [ ] Space 状态显示 "Running"
- [ ] 可以访问 Space URL
- [ ] Web 界面正常加载
- [ ] 可以上传音频文件

## 🧪 功能测试

### Web 界面测试
- [ ] 可以访问 Space 主页
- [ ] 可以拖拽上传音频文件
- [ ] 可以选择语言和模型
- [ ] 点击"提交转录"后显示处理中
- [ ] 最终显示转录结果

### API 测试（可选）
使用以下命令测试 API：

```bash
curl -X POST "https://你的space.hf.space/v1/audio/transcriptions" \
  -H "Authorization: Bearer dummy" \
  -F "file=@test.wav" \
  -F "model=small" \
  -F "response_format=diarized_json"
```

- [ ] API 响应 200 状态码
- [ ] 返回 JSON 格式的转录结果
- [ ] 包含 segments 数组

## ⚠️ 常见问题检查

### 构建失败
- [ ] 检查 Space Logs 查看错误信息
- [ ] 确认 Dockerfile 语法正确
- [ ] 确认所有依赖都在 pyproject.toml 中

### 服务启动失败
- [ ] 检查 FFmpeg 是否正确安装（Dockerfile 已包含）
- [ ] 确认端口配置正确（7860）
- [ ] 查看启动日志查找错误

### 处理速度慢
- [ ] 确认使用的是 CPU basic（免费资源）
- [ ] 考虑使用更小的模型（tiny/base）
- [ ] 这是正常现象，耐心等待

### 空间休眠
- [ ] 重新访问 Space URL 唤醒
- [ ] 等待 1-2 分钟启动完成

## 📊 性能基准

### 首次构建时间
- CPU basic: 5-15 分钟
- CPU upgrade: 3-8 分钟

### 模型首次下载时间
- tiny: ~1 分钟
- base: ~2 分钟
- small: ~3-5 分钟
- medium: ~5-8 分钟
- large-v3: ~8-15 分钟

### 处理速度（CPU basic）
- tiny: ~实时
- base: ~0.5-1x 实时
- small: ~0.3-0.5x 实时
- medium: ~0.2-0.3x 实时
- large-v3: ~0.1-0.2x 实时

*注：实际速度取决于音频长度和复杂度*

## 🎯 成功指标

如果以下所有项目都已完成，说明部署成功：

- ✅ Space 状态显示 "Running"
- ✅ 可以访问 Web 界面
- ✅ 可以上传并转录音频文件
- ✅ 转录结果正确显示
- ✅ API 可以正常调用（如测试）
- ✅ 没有持续的构建或运行错误

## 📞 获取帮助

如果遇到问题：

1. **查看日志**: Space 的 Logs 标签页
2. **阅读文档**:
   - [DEPLOY_TO_HF.md](DEPLOY_TO_HF.md) - 完整部署指南
   - [QUICK_START_HF.md](QUICK_START_HF.md) - 快速开始
   - [CHANGES_FOR_HF_SPACES.md](CHANGES_FOR_HF_SPACES.md) - 更改说明
3. **提交 Issue**: 在原 GitHub 仓库提问题

## 🔄 持续维护

### 定期检查
- [ ] 监控 Space 使用情况
- [ ] 检查日志中的错误
- [ ] 更新依赖（如果需要）

### 优化建议
- [ ] 如需更高性能，考虑升级到 CPU upgrade
- [ ] 如需 GPU，考虑使用其他平台
- [ ] 长期运行建议使用付费计划

---

## 🎉 部署完成！

恭喜！你的 WhisperX API 已成功部署到 Hugging Face Spaces。

现在你可以：
- 🌐 通过 Web 界面使用转录功能
- 🔌 通过 API 集成到你的应用
- 📤 分享你的 Space URL 给他人使用

享受云端语音转录服务吧！
