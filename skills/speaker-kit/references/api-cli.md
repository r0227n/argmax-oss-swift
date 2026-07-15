# SpeakerKit API and CLI

## 主要API

- `open class SpeakerKit`: diarization入口。`diarizer` backendを持つ。
- `SpeakerKitConfig`: backend、download、load、logging設定の基底config。
- `PyannoteConfig`: 既定Pyannote backendのconfig。
- `PyannoteDiarizationOptions`: speaker count、clustering、exclusive reconciliation、clip指定。
- `DiarizationResult`: speaker count、segments、timings、centroid embeddingsを持つ。
- `SpeakerSegment`: speaker、start/end time、transcription、speaker wordsを持つ。
- `SpeakerInfoStrategy`: `.subsegment` または `.segment`。
- `SpeakerKit.generateRTTM`: diarization resultからRTTM lineを作る。
- `RTTMLine`: RTTM出力行。

## よく使う初期化

```swift
let speakerKit = try await SpeakerKit()
```

```swift
let config = PyannoteConfig(
    download: true,
    load: false,
    verbose: false,
    fullRedundancy: true,
    concurrentSegmenterWorkers: 4
)
let speakerKit = try await SpeakerKit(config)
```

```swift
let config = PyannoteConfig(
    modelFolder: "/path/to/models",
    download: false,
    load: true
)
```

## CLI diarize

基本形:

```bash
swift run argmax-cli diarize --audio-path audio.wav --verbose
```

RTTM保存:

```bash
swift run argmax-cli diarize --audio-path audio.wav --rttm-path output.rttm
```

話者数指定:

```bash
swift run argmax-cli diarize --audio-path audio.wav --num-speakers 3
```

ローカルモデル:

```bash
swift run argmax-cli diarize --audio-path audio.wav --model-path /path/to/speakerkit-coreml
```

WhisperKit transcribeと同時にdiarization:

```bash
swift run argmax-cli transcribe --audio-path audio.wav --diarization
```

## 代表的なCLI引数

- `--audio-path`: 入力音声ファイル。
- `--rttm-path`: RTTM保存先。未指定なら標準出力。
- `--model-path`: ローカルモデルフォルダ。
- `--model-repo`: HuggingFace model repo。
- `--model-token`: private repo用token。
- `--download-model-path`: download先。
- `--num-speakers`: 話者数。未指定なら自動推定。
- `--cluster-distance-threshold`: VBx clusteringしきい値。
- `--use-exclusive-reconciliation`: 排他的な後処理を使う。
- `--disable-full-redundancy`: segmenterのfull redundancyを無効化。
- `--verbose`: 詳細ログ。

## 検証コマンド

```bash
swift test --filter SpeakerKitTests
swift run argmax-cli diarize --audio-path Tests/SpeakerKitTests/Resources/jfk.wav --verbose
```

model downloadやCore ML loadを伴う検証は時間がかかる。ロジック変更では `DiarizationResultTests`、`RTTMLineTests`、`ClusterAlgorithmsTests` のような小さいテストを先に走らせる。
