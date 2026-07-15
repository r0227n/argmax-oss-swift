#!/usr/bin/env bash
set -euo pipefail

root="${1:-}"
if [[ -z "$root" ]]; then
  root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fi
cd "$root"

if ! command -v rg >/dev/null 2>&1; then
  printf 'rg is required for this inspection script.\n' >&2
  exit 1
fi

printf '== WhisperKit README section ==\n'
awk '/^## WhisperKit$/{flag=1} /^## TTSKit$/{if(flag) exit} flag {print}' README.md | sed -n '1,220p'

printf '\n== WhisperKit public API ==\n'
rg -n 'open class WhisperKit|public init\(|public convenience init|open func transcribe|open func transcribeWithResults|public static func recommendedModels|public static func download|public struct DecodingOptions|public actor AudioStreamTranscriber' Sources/WhisperKit

printf '\n== CLI transcribe/server entry points ==\n'
rg -n 'struct TranscribeCLI|struct TranscribeCLIArguments|struct ServeCLI|@Option|@Flag|transcribe\(|diarization' Sources/ArgmaxCLI/TranscribeCLI.swift Sources/ArgmaxCLI/TranscribeCLIArguments.swift Sources/ArgmaxCLI/Server/ServeCLI.swift 2>/dev/null || true

printf '\n== Examples ==\n'
rg -n 'WhisperKit|transcribe\(|AudioStreamTranscriber|DecodingOptions' Examples/WhisperAX Examples/ServeCLIClient -g '*.swift' -g '*.md' | sed -n '1,160p'

printf '\n== Tests ==\n'
rg -n 'WhisperKit\(|transcribe\(|DecodingOptions|wordTimestamps|chunkingStrategy' Tests/WhisperKitTests -g '*.swift' | sed -n '1,180p'
