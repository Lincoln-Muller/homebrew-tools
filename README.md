# Lincoln's Homebrew tools

This repository is a personal Homebrew tap. Each tool has its own source folder and a matching formula under `Formula/`.

## Install `transcribe`

```bash
brew tap Lincoln-Muller/tools
brew install transcribe
```

`transcribe` is for audio and video. It uses `mlx-community/whisper-large-v3-turbo` on Apple silicon and writes TXT, SRT, and JSON output.

```bash
transcribe "/path/to/audio-or-video.m4a" "/path/to/output-directory"
transcribe --sequential "/path/to/one.m4a" "/path/to/another.mp4" "/path/to/output-directory"
transcribe --parallel "/path/to/one.m4a" "/path/to/another.mp4" "/path/to/output-directory"
```

The final argument is always the output directory. Each input gets a subfolder named after its filename. Running the command again replaces that input's `.txt`, `.srt`, and `.json` files.

Without `--parallel` or `--sequential`, the command asks you to choose. `--parallel` checks free RAM before starting work. It allows up to two MLX workers only on machines with at least 24 GiB of total RAM and at least 25% free RAM per worker. On an 18 GB Mac, it allows one worker.

The script always passes `--condition-on-previous-text False`, which prevents a bad phrase from being carried into later audio windows. It removes its temporary files and stops its MLX child process when the command exits or is interrupted.

The formula installs FFmpeg and Homebrew Python 3.14. The first transcription run creates a private environment at `$(brew --prefix)/var/transcribe/venv` and installs `mlx-whisper` there. If the older `/usr/local/lib/video-transcriber/venv/` environment still exists, the renamed command reuses it during the transition.

## Maintain the tap

The source for this tool is [`transcribe/transcribe`](transcribe/transcribe). The formula is [`Formula/transcribe.rb`](Formula/transcribe.rb).

1. Edit the source:

   ```bash
   "$EDITOR" "transcribe/transcribe"
   sh -n "transcribe/transcribe"
   ```

2. Calculate the new source checksum and replace the `sha256` value in `Formula/transcribe.rb`:

   ```bash
   shasum -a 256 "transcribe/transcribe"
   ```

3. Bump `version` in the formula, then commit and push both files:

   ```bash
   git add transcribe/transcribe Formula/transcribe.rb README.md
   git commit -m "transcribe: describe the change"
   git push origin main
   ```

4. On the Mac, refresh the tap and reinstall when needed:

   ```bash
   brew update
   brew upgrade transcribe
   ```

The formula is the Homebrew entry point. Homebrew downloads the checked source file, verifies its SHA-256 checksum, installs it as `transcribe`, and declares the system dependencies. The shell script owns the transcription behavior; the formula doesn't duplicate it.
