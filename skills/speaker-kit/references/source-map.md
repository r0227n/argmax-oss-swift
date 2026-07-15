# SpeakerKit source map

## 最初に読むファイル

- `README.md`: SpeakerKit quick example、options、WhisperKit統合、RTTM、CLI。
- `Package.swift`: product `SpeakerKit` と依存関係。
- `Sources/SpeakerKit/SpeakerKit.swift`: public entrypoint、`diarize`、RTTM generation。
- `Sources/SpeakerKit/SpeakerKitConfig.swift`: base config。
- `Sources/SpeakerKit/Pyannote/PyannoteConfig.swift`: `PyannoteConfig` と `PyannoteDiarizationOptions`。
- `Sources/SpeakerKit/DiarizationResult.swift`: segments、speaker info matching、centroid helpers。

## Pyannote backend

- `Sources/SpeakerKit/Pyannote/PyannoteModelManager.swift`: model resolution/load、model container。
- `Sources/SpeakerKit/Pyannote/PyannoteDiarizer.swift`: end-to-end diarization pipeline。
- `Sources/SpeakerKit/Pyannote/SpeakerSegmenterModel.swift`: segmenter Core ML model。
- `Sources/SpeakerKit/Pyannote/SpeakerEmbedderModel.swift`: embedder Core ML model。
- `Sources/SpeakerKit/Pyannote/SpeakerClustering.swift`: speaker clustering orchestration。
- `Sources/SpeakerKit/Pyannote/VBxClustering.swift`: VBx clustering。
- `Sources/SpeakerKit/Pyannote/ClusteringAlgorithms.swift`: clustering algorithms。
- `Sources/SpeakerKit/Pyannote/MathOps.swift`: vector/math utilities。

## speaker labels and RTTM

- `Sources/SpeakerKit/SpeakerSegment.swift`: public speaker segment model。
- `Sources/SpeakerKit/SpeakerInfo.swift`: speaker label、strategy、word timing。
- `Sources/SpeakerKit/RTTMLine.swift`: RTTM line model and word conversion。
- `Sources/SpeakerKit/Diarizer.swift`: backend protocol。
- `Sources/SpeakerKit/SpeakerKitDiarizer.swift`: `ModelManager` bridge。

## CLI and examples

- `Sources/ArgmaxCLI/DiarizeCLI.swift`: standalone diarization CLI。
- `Sources/ArgmaxCLI/TranscribeCLI.swift`: `--diarization` 統合。
- `Examples/WhisperAX/WhisperAX/Views/ContentView.swift`: transcriptionとdiarizationの統合例。

## Tests

- `Tests/SpeakerKitTests/PyannoteIntegrationTests.swift`: end-to-end Pyannote確認。
- `Tests/SpeakerKitTests/DiarizerPostProcessingTests.swift`: post processing。
- `Tests/SpeakerKitTests/ExclusiveReconciliationTests.swift`: exclusive reconciliation。
- `Tests/SpeakerKitTests/DiarizationResultTests.swift`: result processing。
- `Tests/SpeakerKitTests/RTTMLineTests.swift`: RTTM。
- `Tests/SpeakerKitTests/SpeakerCentroidEmbeddingsTests.swift`: centroid embeddings。
- `Tests/SpeakerKitTests/Resources`: audio fixtures。
