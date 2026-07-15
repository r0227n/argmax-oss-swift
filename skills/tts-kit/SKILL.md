---
name: tts-kit
description: TTSKit guidance for Argmax OSS Swift. Use when Codex needs to add, debug, document, or review on-device text-to-speech, Qwen3 TTS model loading, TTSKitConfig, GenerationOptions, voices, languages, playback, audio saving, prompt cache, TTS CLI, or TTSKit example app behavior in this repository.
---

# TTSKit

## 目的

TTSKit を使ったオンデバイス音声合成の実装・調査・説明を支援する。対象はこのリポジトリの `Sources/TTSKit`、`Sources/ArgmaxCLI/TTSCLI.swift`、`Examples/TTS/TTSKitExample`、`Tests/TTSKitTests` にある実装である。

## 進め方

1. 依頼を分類する: text-to-speech生成、streaming playback、音声保存、モデル選択、voice/language設定、style instruction、prompt cache、CLI確認、テスト/不具合調査のどれかを決める。
2. まず `references/source-map.md` で読むべき実装ファイルを選ぶ。
3. 実装例や設定値が必要なら `references/usage.md` を読む。
4. 公開API、CLI引数、検証コマンドを確認するなら `references/api-cli.md` を読む。
5. ローカルの現状を素早く見るときは `scripts/inspect-tts-kit.sh` を実行する。

## 実装ルール

- Swift Package には product `TTSKit` を依存に追加し、Swift では `import TTSKit` を使う。
- 通常は `try await TTSKit()` または `try await TTSKit(TTSKitConfig(...))` で初期化する。
- 既定モデルは `.qwen3TTS_0_6b`。`.qwen3TTS_1_7b` はより重く、style instruction対応とmacOS向けの扱いを前提にする。
- 音声生成は `generate(text:...)`、リアルタイム再生は `play(text:...)` を使う。
- typed APIでは `Qwen3Speaker` と `Qwen3Language` を使う。raw string APIを使う場合は `voice` と `language` のfallbackを確認する。
- 長文では `GenerationOptions` の `chunkingStrategy`、`targetChunkSize`、`minChunkSize`、`concurrentWorkerCount` を調整する。
- `play` では sequential worker が必要なため、CLI実装と同じく `concurrentWorkerCount` を1に寄せる。
- 保存は `AudioOutput.saveAudio` を使い、`.m4a` または `.wav` を選ぶ。

## 参照資料

- `references/usage.md`: 生成、再生、保存、モデル選択、voice/language、style instruction。
- `references/api-cli.md`: 公開API、`GenerationOptions`、CLI引数、代表コマンド。
- `references/source-map.md`: 読むべきソース、例、テストの地図。
