---
name: whisper-kit
description: WhisperKit guidance for Argmax OSS Swift. Use when Codex needs to add, debug, document, or review on-device speech-to-text, transcription, translation, Whisper model loading, DecodingOptions, streaming, CLI transcribe, or local server behavior in this repository.
---

# WhisperKit

## 目的

WhisperKit を使ったオンデバイス音声認識の実装・調査・説明を支援する。対象はこのリポジトリの Swift Package、`Sources/WhisperKit`、`Sources/ArgmaxCLI`、`Examples/WhisperAX`、`Tests/WhisperKitTests` にある実装である。

## 進め方

1. 依頼を分類する: アプリ組み込み、CLI利用、モデル管理、`DecodingOptions` 調整、streaming、local server、テスト/不具合調査のどれかを決める。
2. まず `references/source-map.md` で読むべき実装ファイルを選ぶ。
3. 実装例や設定値が必要なら `references/usage.md` を読む。
4. 公開API、CLI引数、検証コマンドを確認するなら `references/api-cli.md` を読む。
5. ローカルの現状を素早く見るときは `scripts/inspect-whisper-kit.sh` を実行する。

## 実装ルール

- Swift Package には product `WhisperKit` を依存に追加し、Swift では `import WhisperKit` を使う。
- 通常は `try await WhisperKit()` か `try await WhisperKit(WhisperKitConfig(...))` で初期化する。
- `transcribe(audioPath:)` と `transcribe(audioArray:)` は `[TranscriptionResult]` を返す前提で扱う。
- 音声配列を直接渡す場合は、16 kHz mono PCM の `[Float]` として扱う。ファイル読み込みでは `AudioProcessor.loadAudioAsFloatArray` を使う。
- 長尺音声や無音を含む音声では `DecodingOptions(chunkingStrategy: .vad)`、`clipTimestamps`、`concurrentWorkerCount` を検討する。
- word-level alignment が必要な場合は `DecodingOptions(wordTimestamps: true)` を明示する。
- ローカルモデルを使う場合は `WhisperKitConfig(modelFolder: ...)` を優先し、不要なダウンロードを避ける。
- CLI確認では `swift run argmax-cli transcribe ...` を使う。server機能は `BUILD_ALL=1` が必要な構成として扱う。

## 参照資料

- `references/usage.md`: 実装パターン、モデル選択、transcription、streaming、serverの使い分け。
- `references/api-cli.md`: 公開API、`DecodingOptions`、CLI引数、代表コマンド。
- `references/source-map.md`: 読むべきソース、例、テストの地図。
