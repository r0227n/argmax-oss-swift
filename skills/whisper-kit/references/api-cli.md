# WhisperKit API and CLI

## 主要API

- `open class WhisperKit`: model lifecycle、transcription、download、recommended model APIを持つ入口。
- `WhisperKitConfig`: model名、repo、token、folder、compute options、pipeline component、logging、prewarm/load/downloadを設定する。
- `DecodingOptions`: transcription/translationのdecode挙動を設定する。
- `TranscriptionResult`: `.text`、`.segments`、timingsなどを持つ結果。
- `TranscriptionSegment`: segment単位のtext/timestamps/wordsを持つ。
- `AudioStreamTranscriber`: マイク入力とstreaming transcriptionのactor。
- `AudioProcessor`: ファイル読み込み、live recording、energy/VAD補助で使う。
- `WriteJSON`、`WriteSRT`、`WriteVTT`: 結果書き出し用。

## よく使う初期化

```swift
let whisperKit = try await WhisperKit()
```

```swift
let config = WhisperKitConfig(
    model: "tiny",
    verbose: false,
    prewarm: false,
    load: false,
    download: true
)
let whisperKit = try await WhisperKit(config)
```

```swift
let compute = ModelComputeOptions(
    melCompute: .cpuAndGPU,
    audioEncoderCompute: .cpuAndNeuralEngine,
    textDecoderCompute: .cpuAndNeuralEngine
)
let config = WhisperKitConfig(model: "large-v3-v20240930_626MB", computeOptions: compute)
```

## CLI transcribe

基本形:

```bash
swift run argmax-cli transcribe --audio-path audio.wav --model tiny
```

ローカルモデル:

```bash
swift run argmax-cli transcribe \
  --model-path Models/whisperkit-coreml/openai_whisper-tiny \
  --audio-path Tests/WhisperKitTests/Resources/jfk.wav
```

翻訳:

```bash
swift run argmax-cli transcribe --audio-path audio.wav --task translate --language ja
```

word timestamps:

```bash
swift run argmax-cli transcribe --audio-path audio.wav --word-timestamps
```

VAD chunking:

```bash
swift run argmax-cli transcribe --audio-path audio.wav --chunking-strategy vad
```

microphone streaming:

```bash
swift run argmax-cli transcribe --model tiny --stream
```

simulated streaming:

```bash
swift run argmax-cli transcribe --audio-path audio.wav --stream-simulated
```

diarization付きtranscribeはSpeakerKitも関係する:

```bash
swift run argmax-cli transcribe --audio-path audio.wav --diarization
```

## 代表的なCLI引数

- `--audio-path`: 入力音声ファイル。複数指定可能。
- `--audio-folder`: フォルダ内の音声を処理する。
- `--model-path`: ローカルモデルフォルダ。
- `--model`: ダウンロードするモデル名。
- `--download-model-path`: ダウンロード先。
- `--endpoint`: HuggingFace互換endpoint。
- `--audio-encoder-compute-units`: audio encoderのCore ML compute units。
- `--text-decoder-compute-units`: text decoderのCore ML compute units。
- `--task`: `transcribe` または `translate`。
- `--language`: 入力音声の言語。
- `--temperature`: sampling温度。
- `--word-timestamps`: word timestampsを出す。
- `--clip-timestamps`: 秒単位のclip境界。
- `--stream`: マイク入力。
- `--stream-simulated`: ファイル入力でstreaming風に処理する。
- `--concurrent-worker-count`: 並列推論数。
- `--chunking-strategy`: `none` または `vad`。

## 検証コマンド

```bash
swift test --filter WhisperKitTests
swift run argmax-cli transcribe --audio-path Tests/WhisperKitTests/Resources/jfk.wav --model tiny
```

モデルダウンロードやCore ML specializationが走る検証は時間とディスク容量を使う。軽い確認ではunit testや既存fixtureを優先する。
