# WhisperKit usage

## まず見ること

- アプリに組み込むなら `WhisperKitConfig` と `DecodingOptions` を確認する。
- CLIで再現するなら `swift run argmax-cli transcribe --help` 相当の引数を確認する。
- streamingやマイク入力なら `AudioStreamTranscriber` と `Examples/WhisperAX` を読む。
- server互換APIなら `Sources/ArgmaxCLI/Server` を読む。server build は `BUILD_ALL=1` が必要。

## Swift Packageで使う

`Package.swift` では product `WhisperKit` を依存に追加する。

```swift
.package(url: "https://github.com/argmaxinc/argmax-oss-swift.git", from: "x.y.z")
```

```swift
.product(name: "WhisperKit", package: "argmax-oss-swift")
```

Swift側では次の形を基本にする。

```swift
import WhisperKit

let whisperKit = try await WhisperKit()
let results = try await whisperKit.transcribe(audioPath: audioPath)
let text = results.map(\.text).joined(separator: " ")
```

## モデル選択

- 指定なしの `WhisperKit()` はデバイス推奨モデルを解決する。
- 高精度の多言語用途では README の推奨に従い `large-v3-v20240930_626MB` を検討する。
- デバッグやCIの短時間確認では `tiny` または `tiny.en` を使う。
- 独自repoやprivate repoでは `modelRepo` と `modelToken` を使う。
- ローカルに展開済みのモデルを使う場合は `modelFolder` を渡す。

```swift
let config = WhisperKitConfig(
    model: "large-v3-v20240930_626MB",
    verbose: false
)
let whisperKit = try await WhisperKit(config)
```

```swift
let config = WhisperKitConfig(
    modelFolder: "/path/to/openai_whisper-large-v3-v20240930_626MB",
    download: false,
    verbose: false
)
let whisperKit = try await WhisperKit(config)
```

## transcription

ファイル入力では `transcribe(audioPath:)` を使う。複数ファイルでは `transcribe(audioPaths:)` または `transcribeWithResults(audioPaths:)` を使う。

```swift
let options = DecodingOptions(
    task: .transcribe,
    language: "ja",
    temperature: 0,
    wordTimestamps: true,
    chunkingStrategy: .vad
)

let results = try await whisperKit.transcribe(
    audioPath: audioPath,
    decodeOptions: options
)
```

音声配列を渡す場合は 16 kHz mono PCM `[Float]` を渡す。

```swift
let audio = try AudioProcessor.loadAudioAsFloatArray(fromPath: audioPath)
let results = try await whisperKit.transcribe(audioArray: audio, decodeOptions: options)
```

## DecodingOptionsの使い分け

- `task`: `.transcribe` は同一言語への文字起こし、`.translate` は英語翻訳。
- `language`: 既知なら `"en"` や `"ja"` を指定する。未知なら `detectLanguage` の挙動も確認する。
- `wordTimestamps`: word単位の時刻やSpeakerKit連携が必要なときに有効化する。
- `withoutTimestamps`: timestamp不要のテキスト中心出力で使う。
- `clipTimestamps`: 音声内の範囲を秒で指定する。
- `chunkingStrategy`: 長尺音声や無音区間が多い場合は `.vad` を使う。
- `concurrentWorkerCount`: macOSでは既定が大きめ、非macOSでは抑えめ。端末負荷に合わせる。

## progress callback

`TranscriptionCallback` は途中経過、tokens、timingsを受け取る。戻り値で早期停止を制御できる。

```swift
let results = try await whisperKit.transcribe(audioPath: audioPath) { progress in
    print(progress.text)
    return true
}
```

## streaming

簡易確認はCLIの `--stream` を使う。

```bash
swift run argmax-cli transcribe --model tiny --stream
```

アプリ実装では `AudioStreamTranscriber` がマイク入力、VAD、確定/未確定segment管理を担当する。`Examples/WhisperAX` の `ContentView.swift` と watch example を読み、UI stateとpermission処理を既存パターンに合わせる。

## local server

OpenAI Audio API互換のlocal serverは `Sources/ArgmaxCLI/Server` にある。通常のSwift Package依存ではserver依存が無効で、ビルド時に `BUILD_ALL=1` が必要。

```bash
BUILD_ALL=1 swift build --product argmax-cli
swift run argmax-cli serve --help
```
