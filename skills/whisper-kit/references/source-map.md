# WhisperKit source map

## 最初に読むファイル

- `README.md`: user-facing examples、model selection、CLI、server説明。
- `Package.swift`: product `WhisperKit` と CLI target の依存関係。
- `Sources/WhisperKit/Core/WhisperKit.swift`: 初期化、model download/load、transcribe入口。
- `Sources/WhisperKit/Core/Configurations.swift`: `WhisperKitConfig` と `DecodingOptions`。
- `Sources/WhisperKit/Core/Models.swift`: `ModelVariant`、`ModelComputeOptions`、model support。

## audioとstreaming

- `Sources/WhisperKit/Core/Audio/AudioProcessor.swift`: 音声読み込み、recording、energy処理。
- `Sources/WhisperKit/Core/Audio/AudioStreamTranscriber.swift`: streaming transcription actor。
- `Sources/WhisperKit/Core/Audio/VoiceActivityDetector.swift`: VAD protocol。
- `Sources/WhisperKit/Core/Audio/EnergyVAD.swift`: 既定VAD実装。
- `Sources/WhisperKit/Core/Audio/AudioChunker.swift`: chunking処理。

## decodingと結果

- `Sources/WhisperKit/Core/TranscribeTask.swift`: window単位のtranscription pipeline。
- `Sources/WhisperKit/Core/TextDecoder.swift`: decode処理。
- `Sources/WhisperKit/Core/Text/TokenSampler.swift`: sampling。
- `Sources/WhisperKit/Utilities/TranscriptionUtilities.swift`: result mergeやtiming補助。
- `Sources/WhisperKit/Utilities/ResultWriter.swift`: JSON/SRT/VTT writer。

## CLI/server

- `Sources/ArgmaxCLI/TranscribeCLI.swift`: transcribe command本体。
- `Sources/ArgmaxCLI/TranscribeCLIArguments.swift`: CLI引数。
- `Sources/ArgmaxCLI/TranscribeCLIUtils.swift`: CLIからconfig/optionsを作る補助。
- `Sources/ArgmaxCLI/Server/OpenAIHandler.swift`: OpenAI Audio API互換処理。
- `Sources/ArgmaxCLI/Server/ServeCLI.swift`: local server起動。

## Examples

- `Examples/WhisperAX/WhisperAX/Views/ContentView.swift`: iOS/macOS styleの統合例、SpeakerKit連携も含む。
- `Examples/WhisperAX/WhisperAXWatchApp/WhisperAXExampleView.swift`: watchOS向けstreaming例。
- `Examples/ServeCLIClient`: local server client examples。

## Tests

- `Tests/WhisperKitTests/UnitTests.swift`: decode options、audio fixtures、regression補助。
- `Tests/WhisperKitTests/FunctionalTests.swift`: model folderやtranscription動作。
- `Tests/WhisperKitTests/RegressionTests.swift`: benchmark/regression flow。
- `Tests/WhisperKitTests/TestUtils.swift`: test helper。
- `Tests/WhisperKitTests/Resources`: small audio fixtures。
