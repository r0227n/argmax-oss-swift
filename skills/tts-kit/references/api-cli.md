# TTSKit API and CLI

## 主要API

- `open class TTSKit`: text chunking、model orchestration、generation、playbackの入口。
- `TTSKitConfig`: model variant、repo/folder/token、component variants、compute options、load/download/prewarm、seedを設定する。
- `TTSModelVariant`: `.qwen3TTS_0_6b` と `.qwen3TTS_1_7b`。
- `Qwen3Speaker`: built-in voices。
- `Qwen3Language`: supported languages。
- `GenerationOptions`: sampling、chunking、concurrency、style instruction。
- `SpeechResult`: generated audio、timings、sample rate。
- `SpeechProgress`: callbackで渡されるstep progress。
- `PlaybackStrategy`: `play` のbuffering strategy。
- `AudioOutput`: playbackとaudio save。
- `TTSPromptCache`: prompt prefix cache。

## よく使う初期化

```swift
let tts = try await TTSKit()
```

```swift
let config = TTSKitConfig(
    model: .qwen3TTS_0_6b,
    verbose: false,
    seed: 42
)
let tts = try await TTSKit(config)
```

```swift
let compute = ComputeOptions(
    embedderComputeUnits: .cpuOnly,
    codeDecoderComputeUnits: .cpuAndNeuralEngine,
    multiCodeDecoderComputeUnits: .cpuAndNeuralEngine,
    speechDecoderComputeUnits: .cpuAndNeuralEngine
)
let config = TTSKitConfig(model: .qwen3TTS_0_6b, computeOptions: compute)
```

## CLI tts

基本形:

```bash
swift run argmax-cli tts --text "Hello from the command line"
```

再生:

```bash
swift run argmax-cli tts --text "Hello" --play
```

保存:

```bash
swift run argmax-cli tts --text "Save to file" --output-path output --output-format wav
```

日本語:

```bash
swift run argmax-cli tts --text "日本語テスト" --speaker ono-anna --language japanese
```

text file:

```bash
swift run argmax-cli tts --text-file article.txt --model 1.7b --instruction "Read cheerfully"
```

ローカルモデル:

```bash
swift run argmax-cli tts --text "Hello" --models-path /path/to/ttskit-coreml
```

## 代表的なCLI引数

- `--text`: 合成するtext。
- `--text-file`: `.txt` または `.md` から読む。
- `--speaker`: `aiden`、`ryan`、`ono-anna`、`sohee`、`eric`、`dylan`、`serena`、`vivian`、`uncle-fu`。
- `--language`: `english`、`chinese`、`japanese`、`korean` など。
- `--output-path`: 保存先。拡張子はCLI内でformatに合わせる。
- `--output-format`: `m4a` または `wav`。
- `--play`: 生成しながら再生。
- `--temperature`: sampling温度。
- `--top-k`: top-k sampling。
- `--max-new-tokens`: RVQ frame上限。
- `--concurrent-worker-count`: chunk worker数。`--play` では既定1、それ以外は既定0。
- `--target-chunk-size`: sentence splitの目標文字数。
- `--min-chunk-size`: 短い末尾chunkをまとめるための最小文字数。
- `--instruction`: style instruction。1.7Bのみ。
- `--seed`: 再現性用seed。
- `--model`: `0.6b` または `1.7b`。
- `--models-path`: ローカルモデルフォルダ。
- `--model-repo`: model repo。
- `--token`: HuggingFace token。
- `--endpoint`: HuggingFace互換endpoint。
- `--code-decoder-variant`: component variant override。
- `--multi-code-decoder-variant`: component variant override。
- `--speech-decoder-variant`: component variant override。
- compute unit options: `--embedder-compute-units`、`--code-decoder-compute-units`、`--multi-code-decoder-compute-units`、`--speech-decoder-compute-units`。

## 検証コマンド

```bash
swift test --filter TTSKitTests
swift run argmax-cli tts --text "Hello" --model 0.6b --output-path /tmp/tts-output --output-format wav
```

model downloadとCore ML loadを伴う統合テストは重い。ロジック変更では `TTSKitUnitTests` を先に走らせ、実モデル確認は必要な範囲に絞る。
