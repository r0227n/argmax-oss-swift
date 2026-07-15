# SpeakerKit usage

## まず見ること

- 単独の話者分離なら `SpeakerKit`、`PyannoteConfig`、`PyannoteDiarizationOptions` を確認する。
- WhisperKitとの統合なら `DiarizationResult.addSpeakerInfo(to:)` と `SpeakerInfoStrategy` を確認する。
- RTTMが必要なら `SpeakerKit.generateRTTM` と `RTTMLine` を確認する。
- CLIで再現するなら `swift run argmax-cli diarize --help` 相当の引数を確認する。

## Swift Packageで使う

`Package.swift` では product `SpeakerKit` を依存に追加する。

```swift
.product(name: "SpeakerKit", package: "argmax-oss-swift")
```

Swift側では次の形を基本にする。

```swift
import SpeakerKit
import WhisperKit

let speakerKit = try await SpeakerKit()
let audio = try AudioProcessor.loadAudioAsFloatArray(fromPath: audioPath)
let result = try await speakerKit.diarize(audioArray: audio)
```

## 入力音声

`diarize(audioArray:)` には 16 kHz mono PCM の `[Float]` を渡す。ファイル入力では `AudioProcessor.loadAudioAsFloatArray(fromPath:)` を使うと、この前処理を既存実装に合わせやすい。

```swift
let audio = try AudioProcessor.loadAudioAsFloatArray(fromPath: "meeting.wav")
```

## モデルと初期化

既定では `PyannoteConfig()` が使われる。モデルは `argmaxinc/speakerkit-coreml` から取得され、`load: false` の場合は初回 `diarize` でロードされる。

```swift
let speakerKit = try await SpeakerKit(PyannoteConfig(verbose: false))
```

ローカルモデルを使う場合:

```swift
let config = PyannoteConfig(
    modelFolder: "/path/to/speakerkit-coreml",
    download: false,
    load: true,
    verbose: false
)
let speakerKit = try await SpeakerKit(config)
```

private repoやmirrorを使う場合は `modelRepo`、`modelToken`、`modelEndpoint` を設定する。

## Diarization options

話者数が分かっている場合は `numberOfSpeakers` を指定する。未知なら `nil` のまま自動推定に任せる。

```swift
let options = PyannoteDiarizationOptions(
    numberOfSpeakers: 3,
    clusterDistanceThreshold: 0.6,
    useExclusiveReconciliation: true
)
let result = try await speakerKit.diarize(audioArray: audio, options: options)
```

主な調整点:

- `numberOfSpeakers`: 既知の話者数。
- `clusterDistanceThreshold`: clusteringの距離しきい値。
- `minClusterSize`: 小さいclusterの扱い。
- `minActiveOffset`: segment結合の時間オフセット。
- `useExclusiveReconciliation`: frameごとに排他的な話者割当を行う。
- `centroidSource`: cross-run speaker matching用centroidの作り方。
- `clipTimestamps`: 秒単位の処理範囲。

## WhisperKitとの統合

話者付き文字起こしでは同じaudio samplesをWhisperKitとSpeakerKitに渡す。

```swift
import WhisperKit
import SpeakerKit

let whisperKit = try await WhisperKit()
let speakerKit = try await SpeakerKit()
let audio = try AudioProcessor.loadAudioAsFloatArray(fromPath: audioPath)

let transcription = try await whisperKit.transcribe(
    audioArray: audio,
    decodeOptions: DecodingOptions(wordTimestamps: true)
)
let diarization = try await speakerKit.diarize(audioArray: audio)
let speakerSegments = diarization.addSpeakerInfo(to: transcription)
```

`SpeakerInfoStrategy.subsegment` はword gapsでsegmentを細分化して話者を割り当てる。word timingsがないtranscriptionでは精度が落ちるため、WhisperKit側で `wordTimestamps: true` を使う。

## RTTM

diarizationのみのRTTM:

```swift
let lines = SpeakerKit.generateRTTM(from: diarization, fileName: "meeting")
let content = lines.map(\.description).joined(separator: "\n")
```

transcriptionに合わせたRTTM:

```swift
let lines = SpeakerKit.generateRTTM(
    from: diarization,
    strategy: .subsegment,
    transcription: transcription,
    fileName: "meeting"
)
```

## centroid embeddings

`DiarizationResult.speakerCentroidEmbeddings` は話者clusterのcentroidを保持する。別々の `diarize` 結果間で同一話者らしさを比較する場合は `centroidCosineDistance` や `nearestSpeakerCentroid(to:)` を使う。ただしSpeakerKitは普遍的なしきい値を定義しないため、アプリ側で音声条件に合わせて調整する。
