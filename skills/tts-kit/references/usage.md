# TTSKit usage

## まず見ること

- text-to-speech生成なら `TTSKit`、`TTSKitConfig`、`GenerationOptions` を確認する。
- voiceやlanguageなら `Qwen3Speaker` と `Qwen3Language` を確認する。
- streaming playbackなら `play` と `PlaybackStrategy` を確認する。
- 保存なら `AudioOutput.saveAudio` を確認する。
- CLIやexample appなら `Sources/ArgmaxCLI/TTSCLI.swift` と `Examples/TTS/TTSKitExample` を読む。

## Swift Packageで使う

`Package.swift` では product `TTSKit` を依存に追加する。

```swift
.product(name: "TTSKit", package: "argmax-oss-swift")
```

Swift側では次の形を基本にする。

```swift
import TTSKit

let tts = try await TTSKit()
let result = try await tts.generate(text: "Hello from TTSKit!")
print(result.audioDuration)
```

## platformとモデル

READMEではTTSKitの実行環境として macOS 15.0 以降、iOS 18.0 以降が示されている。Package全体のplatformとは別に、Qwen3 TTSのCore ML実行条件として扱う。

モデルvariant:

- `.qwen3TTS_0_6b`: 既定。軽量で通常の実装に向く。
- `.qwen3TTS_1_7b`: 高品質寄り。style instruction対応。現実的にはmacOS向けとして扱う。

```swift
let fast = try await TTSKit(TTSKitConfig(model: .qwen3TTS_0_6b))
let quality = try await TTSKit(TTSKitConfig(model: .qwen3TTS_1_7b))
```

## voice and language

typed APIを優先する。

```swift
let result = try await tts.generate(
    text: "こんにちは世界",
    speaker: .onoAnna,
    language: .japanese
)
```

利用可能なspeaker:

- `.ryan`
- `.aiden`
- `.onoAnna`
- `.sohee`
- `.eric`
- `.dylan`
- `.serena`
- `.vivian`
- `.uncleFu`

利用可能なlanguage:

- `.english`
- `.chinese`
- `.japanese`
- `.korean`
- `.german`
- `.french`
- `.russian`
- `.portuguese`
- `.spanish`
- `.italian`

## GenerationOptions

```swift
var options = GenerationOptions()
options.temperature = 0.9
options.topK = 50
options.repetitionPenalty = 1.05
options.maxNewTokens = 245
options.concurrentWorkerCount = 0
options.targetChunkSize = 120
options.minChunkSize = 40
```

使い分け:

- `temperature`: 出力の揺らぎ。
- `topK`: sampling候補数。
- `repetitionPenalty`: 反復抑制。
- `maxNewTokens`: 生成するRVQ frame上限。
- `concurrentWorkerCount`: `0` は最大並列、`1` は逐次、`N` は並列上限。
- `targetChunkSize` / `minChunkSize`: 長文分割。
- `instruction`: style instruction。1.7Bのみ有効に扱う。

## playback

`play` は生成しながらデバイススピーカーへ送る。既定の `.auto` は初回stepの速度からbufferを決める。

```swift
try await tts.play(
    text: "This starts playing before generation finishes.",
    speaker: .ryan,
    language: .english,
    playbackStrategy: .auto
)
```

`PlaybackStrategy`:

- `.auto`: 既定。速度に応じてbufferを調整。
- `.stream`: 即時stream。遅い環境では途切れやすい。
- `.buffered(seconds:)`: 固定秒数をbuffer。
- `.generateFirst`: 全生成後に再生。低リスクだがlatencyが高い。

`play` ではリアルタイム順序が必要なため、長文chunkは逐次処理に寄せる。CLIも `--play` では既定workerを1にする。

## 保存

```swift
let result = try await tts.generate(text: "Save me!", speaker: .ryan)
let outputDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
try await AudioOutput.saveAudio(
    result.audio,
    toFolder: outputDir,
    filename: "output",
    format: .m4a
)
```

## callbackとcancel

callbackはstepごとの音声chunkとtimingsを受け取る。`false` を返すとcancelする。

```swift
let result = try await tts.generate(text: "Hello") { progress in
    print(progress.audio.count)
    return true
}
```

## prompt cache

同じspeaker/language/instructionで連続生成する場合はprefix stateをcacheできる。

```swift
try await tts.buildPromptCache(
    speaker: .ryan,
    language: .english,
    instruction: nil
)
```

cacheを明示的に保存/復元する場合は `savePromptCache` と `loadPromptCache` を確認する。

## style instruction

`GenerationOptions.instruction` は `.qwen3TTS_1_7b` 向け。0.6BではCLI実装と同じく無視または警告扱いにする。

```swift
var options = GenerationOptions()
options.instruction = "Speak slowly and warmly."
let result = try await tts.generate(text: text, speaker: .ryan, options: options)
```
