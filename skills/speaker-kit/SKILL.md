---
name: speaker-kit
description: SpeakerKit guidance for Argmax OSS Swift. Use when Codex needs to add, debug, document, or review on-device speaker diarization, PyannoteConfig, PyannoteDiarizationOptions, speaker-attributed transcription, RTTM output, diarization CLI, or SpeakerKit model loading in this repository.
---

# SpeakerKit

## 目的

SpeakerKit を使ったオンデバイス話者分離の実装・調査・説明を支援する。対象はこのリポジトリの `Sources/SpeakerKit`、WhisperKit連携、`Sources/ArgmaxCLI/DiarizeCLI.swift`、`Examples/WhisperAX`、`Tests/SpeakerKitTests` にある実装である。

## 進め方

1. 依頼を分類する: 単独diarization、WhisperKitとの話者付き文字起こし統合、RTTM出力、モデル配置、Pyannote tuning、CLI確認、テスト/不具合調査のどれかを決める。
2. まず `references/source-map.md` で読むべき実装ファイルを選ぶ。
3. 実装例や設定値が必要なら `references/usage.md` を読む。
4. 公開API、CLI引数、検証コマンドを確認するなら `references/api-cli.md` を読む。
5. ローカルの現状を素早く見るときは `scripts/inspect-speaker-kit.sh` を実行する。

## 実装ルール

- Swift Package には product `SpeakerKit` を依存に追加し、Swift では `import SpeakerKit` を使う。
- 通常は `try await SpeakerKit()` または `try await SpeakerKit(PyannoteConfig(...))` で初期化する。
- 入力音声は 16 kHz mono PCM の `[Float]` として扱う。ファイルから読む場合は `AudioProcessor.loadAudioAsFloatArray(fromPath:)` を使う。
- 既定の backend は `PyannoteConfig()` で、モデルは `argmaxinc/speakerkit-coreml` から取得される。
- モデルの事前ロードが必要なら `load: true`、初回推論まで遅延したいなら既定の `load: false` を使う。
- 話者数が分かっている場合は `PyannoteDiarizationOptions(numberOfSpeakers:)` を使い、自動推定に任せる場合は `nil` にする。
- WhisperKitの結果へ話者を付与する場合は `diarization.addSpeakerInfo(to:)` を使う。word単位の品質が必要ならWhisperKit側で `wordTimestamps` を有効にする。
- RTTM出力は `SpeakerKit.generateRTTM(from:fileName:)` を使う。

## 参照資料

- `references/usage.md`: diarization、Pyannote設定、WhisperKit連携、RTTM出力。
- `references/api-cli.md`: 公開API、`PyannoteDiarizationOptions`、CLI引数、代表コマンド。
- `references/source-map.md`: 読むべきソース、例、テストの地図。
