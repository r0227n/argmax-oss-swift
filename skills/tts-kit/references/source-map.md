# TTSKit source map

## 最初に読むファイル

- `README.md`: TTSKit quick example、model selection、voice/language、playback、CLI、demo app。
- `Package.swift`: product `TTSKit` と CLI target の依存関係。
- `Sources/TTSKit/TTSKit.swift`: public entrypoint、download/load、generate、play、prompt cache。
- `Sources/TTSKit/Qwen3TTS/Qwen3Config.swift`: `TTSModelVariant` と `TTSKitConfig`。
- `Sources/TTSKit/Models.swift`: `GenerationOptions`、`SpeechResult`、`PlaybackStrategy`、timings。
- `Sources/TTSKit/Configurations.swift`: `ComputeOptions`。

## Qwen3 components

- `Sources/TTSKit/Qwen3TTS/Qwen3Models.swift`: `Qwen3Speaker`、`Qwen3Language`、token IDs。
- `Sources/TTSKit/Qwen3TTS/Qwen3GenerateTask.swift`: generation task本体。
- `Sources/TTSKit/Qwen3TTS/Qwen3CodeDecoder.swift`: autoregressive code decoder。
- `Sources/TTSKit/Qwen3TTS/Qwen3MultiCodeDecoder.swift`: multi-code decoder。
- `Sources/TTSKit/Qwen3TTS/Qwen3SpeechDecoder.swift`: waveform decoder。
- `Sources/TTSKit/Qwen3TTS/Qwen3Embedders.swift`: code embedders。
- `Sources/TTSKit/Qwen3TTS/Qwen3TextProjector.swift`: text projector。

## utilities

- `Sources/TTSKit/Utilities/TextChunker.swift`: long text chunking。
- `Sources/TTSKit/Utilities/AudioOutput.swift`: playbackとsave。
- `Sources/TTSKit/Utilities/Sampling.swift`: sampling helpers。
- `Sources/TTSKit/Utilities/KVCache.swift`: KV cache。
- `Sources/TTSKit/Utilities/PromptCache.swift`: prompt cache。
- `Sources/TTSKit/Utilities/TTSError.swift`: error。

## CLI and examples

- `Sources/ArgmaxCLI/TTSCLI.swift`: TTS CLI本体。
- `Examples/TTS/TTSKitExample/README.md`: example app build/use。
- `Examples/TTS/TTSKitExample/TTSKitExample/ViewModel.swift`: model management、generation、streaming UI。
- `Examples/TTS/TTSKitExample/TTSKitExample/GenerationSettingsView.swift`: user-facing generation settings。
- `Examples/TTS/TTSKitExample/TTSKitExample/ModelManagementView.swift`: model management UI。

## Tests

- `Tests/TTSKitTests/TTSKitUnitTests.swift`: config、chunking、sampling、cache周辺。
- `Tests/TTSKitTests/TTSKitIntegrationTests.swift`: real generation path。
