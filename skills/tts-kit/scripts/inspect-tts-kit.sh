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

printf '== TTSKit README section ==\n'
awk '/^## TTSKit$/{flag=1} /^## SpeakerKit$/{if(flag) exit} flag {print}' README.md | sed -n '1,220p'

printf '\n== TTSKit public API ==\n'
rg -n 'open class TTSKit|open class TTSKitConfig|public enum TTSModelVariant|public enum Qwen3Speaker|public enum Qwen3Language|public struct GenerationOptions|public enum PlaybackStrategy|open func generate|open func play|public func savePromptCache|public func loadPromptCache|public struct SpeechResult' Sources/TTSKit

printf '\n== CLI tts entry point ==\n'
rg -n 'struct TTSCLI|@Option|@Flag|generate\(|play\(|AudioOutput.saveAudio' Sources/ArgmaxCLI/TTSCLI.swift | sed -n '1,220p'

printf '\n== Example app ==\n'
rg -n 'TTSKit|TTSKitConfig|generate\(|play\(|GenerationOptions|Qwen3Speaker|Qwen3Language' Examples/TTS/TTSKitExample -g '*.swift' -g '*.md' | sed -n '1,220p'

printf '\n== Tests ==\n'
rg -n 'TTSKit\(|TTSKitConfig|GenerationOptions|generate\(|PlaybackStrategy|PromptCache|Qwen3Speaker|Qwen3Language' Tests/TTSKitTests -g '*.swift' | sed -n '1,220p'
