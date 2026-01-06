---
title: WhisperX API with Web UI
emoji: 🎙️
colorFrom: blue
colorTo: purple
sdk: docker
pinned: false
license: mit
---

# WhisperX API with Web UI

欢迎使用 WhisperX API 服务！这是一个提供高精度语音转录和说话人分离功能的在线服务。

## 🚀 使用方法

### Web 界面

直接访问本 Space 的主页，拖拽或点击上传音频/视频文件，选择语言和模型参数，即可开始转录。

### API 调用

本服务兼容 OpenAI Whisper API 格式：

```python
from openai import OpenAI

client = OpenAI(
    base_url='https://your-space.hf.space/v1',
    api_key='dummy-key'  # 可以是任意值
)

with open("audio.wav", "rb") as audio_file:
    transcript = client.audio.transcriptions.create(
        model="large-v3",
        file=audio_file,
        response_format="diarized_json",
        extra_body={
            "max_speakers": 0,  # 启用说话人分离
            "min_speakers": 0
        },
    )

for segment in transcript.segments:
    speaker = segment.get('speaker', 'Unknown')
    print(f"{speaker}: {segment['text']}")
```

## ⚠️ 注意事项

- 本 Space 运行在免费 CPU 资源上，处理速度较慢，请耐心等待
- 首次使用某个模型时需要下载，可能需要较长时间
- 推荐使用 `small` 或 `medium` 模型以平衡速度和准确度
- 长音频文件（>30分钟）可能超时，建议分段处理

## 📝 模型选择

- `tiny` - 最快，准确度较低
- `base` - 速度较快
- `small` - 平衡选择（推荐）
- `medium` - 较慢但更准确
- `large-v3` - 最准确但很慢

完整文档和源代码请访问：[GitHub 仓库](https://github.com/jianchang512/whisperx-api)
