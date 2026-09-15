# Lincoln's Homebrew tools

This repository is a personal Homebrew tap. Each tool has its own source folder
and a matching formula under Formula/.

## Install

~~~bash
brew tap Lincoln-Muller/tools
brew install transcribe
~~~

## Use

~~~bash
# One file: no mode question; output goes to the current directory
transcribe "/path/to/audio-or-video.m4a"

# Several files: output goes to the current directory
transcribe --sequential "/path/to/one.m4a" "/path/to/two.mp4"
transcribe --parallel "/path/to/one.m4a" "/path/to/two.mp4"

# An existing final directory is used as the output directory
transcribe "/path/to/one.m4a" "/path/to/two.mp4" "/path/to/output"
~~~

Transcribe accepts audio and video files and uses
mlx-community/whisper-large-v3-turbo on Apple silicon. Each input is written
to <output>/<input-name>/ as TXT, SRT, and JSON. Matching output files are
replaced; unrelated files are kept.

When more than one input is supplied without a mode flag, the command shows a
10-second countdown:

1. Enter 1 for parallel.
2. Enter 2 for sequential.
3. If no choice is entered, parallel is selected.

A single input runs sequentially without asking. The final argument is treated
as an output directory only when it already exists. Otherwise all arguments are
inputs and the output directory is the current directory (.). Create a custom directory first if
needed.

Parallel mode checks free RAM before launching each worker. It reserves 25% of
free RAM per worker, allows at most one worker below 24 GiB of total memory, and
allows at most two workers at or above 24 GiB. It waits when free RAM is low.
Each MLX worker exits after its file, and temporary files are removed when the
command finishes or is interrupted. The command passes
--condition-on-previous-text False to avoid carrying a bad phrase into the next
audio window.

The first transcription creates a private environment at
$(brew --prefix)/var/transcribe/venv and installs mlx-whisper there. An older
/usr/local/lib/video-transcriber/venv/ environment is reused during the rename
transition.

## Maintain the tap

Source: transcribe/transcribe
Formula: Formula/transcribe.rb

1. Edit the source and check its syntax:

   ~~~bash
   "$EDITOR" "transcribe/transcribe"
   sh -n "transcribe/transcribe"
   ~~~

2. Recompute the source checksum:

   ~~~bash
   shasum -a 256 "transcribe/transcribe"
   ~~~

3. Bump the formula version and update its sha256, then commit and push:

   ~~~bash
   git add transcribe/transcribe Formula/transcribe.rb README.md
   git commit -m "transcribe: describe change"
   git push origin main
   ~~~

4. Refresh a local installation:

   ~~~bash
   brew update
   brew upgrade transcribe
   ~~~

The formula downloads the checked source file, verifies its SHA-256 checksum,
installs it as transcribe, and declares FFmpeg and Homebrew Python 3.14 as
dependencies. The shell script owns transcription behavior.
