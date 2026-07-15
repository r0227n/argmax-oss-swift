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

printf '== SpeakerKit README section ==\n'
awk '/^## SpeakerKit$/{flag=1} /^## Contributing & Roadmap$/{if(flag) exit} flag {print}' README.md | sed -n '1,220p'

printf '\n== SpeakerKit public API ==\n'
rg -n 'open class SpeakerKit|open class SpeakerKitConfig|public class PyannoteConfig|public struct PyannoteDiarizationOptions|public struct DiarizationResult|public struct SpeakerSegment|public enum SpeakerInfo|public enum SpeakerInfoStrategy|open class func generateRTTM|open func diarize' Sources/SpeakerKit

printf '\n== CLI diarize/transcribe entry points ==\n'
rg -n 'struct DiarizeCLI|@Option|@Flag|diarize\(|generateRTTM|diarization' Sources/ArgmaxCLI/DiarizeCLI.swift Sources/ArgmaxCLI/TranscribeCLI.swift | sed -n '1,220p'

printf '\n== Examples ==\n'
rg -n 'SpeakerKit|diarize\(|addSpeakerInfo|Pyannote|generateRTTM' Examples/WhisperAX -g '*.swift' -g '*.md' | sed -n '1,180p'

printf '\n== Tests ==\n'
rg -n 'SpeakerKit\(|diarize\(|PyannoteDiarizationOptions|generateRTTM|addSpeakerInfo|centroid' Tests/SpeakerKitTests -g '*.swift' | sed -n '1,220p'
