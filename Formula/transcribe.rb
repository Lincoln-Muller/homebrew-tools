class Transcribe < Formula
  desc "Batch audio and video transcription on Apple silicon"
  homepage "https://github.com/Lincoln-Muller/homebrew-tools"
  url "https://raw.githubusercontent.com/Lincoln-Muller/homebrew-tools/main/transcribe/transcribe", using: :nounzip
  version "0.2.0"
  sha256 "c8dc3e16c667646a1c135e02011c60366c46ff53abc02e26a8a4ad00778e2829"

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
