class Transcribe < Formula
  desc "Batch audio and video transcription on Apple silicon"
  homepage "https://github.com/Lincoln-Muller/homebrew-tools"
  url "https://raw.githubusercontent.com/Lincoln-Muller/homebrew-tools/main/transcribe/transcribe", using: :nounzip
  sha256 "06dbf1d0c4be2ac5f163507d41cfe4e03285611a4eadf899b4e1c121cefb542d"
  version "0.1.0"

  depends_on arch: :arm64
  depends_on "ffmpeg"
  depends_on "python@3.14"

  def install
    bin.install "transcribe"
  end

  test do
    assert_match "Usage: transcribe", shell_output("#{bin}/transcribe --help")
  end
end
