class Whitemagic < Formula
  desc "Local-first memory and session continuity for AI agents"
  homepage "https://www.whitemagic.dev"
  version "9.3.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-macos-aarch64"
      sha256 "01b3e23fc503ce0dffce0df14c7c1f1f8725ba8a9bf22aa9ce5666497be33156"
    end
    on_intel do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-macos-x86_64"
      sha256 "74e5351133c27a8948cd65f00ba8e7a5da47da48ef039f879ff72451e812aeec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-linux-aarch64-musl"
      sha256 "2ecd7679b3ee16b7166512cd5f56103d588bddf28c5117db5dc6a8a01f6b8847"
    end
    on_intel do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-linux-x86_64-musl"
      sha256 "180e2912ef35a12975fc390040e11afcda671b9f576609a048bbc6c30491c07c"
    end
  end

  def install
    binary = Dir["wm-*"].first
    odie "release asset missing from the download" if binary.nil?
    bin.install binary => "wm"
  end

  def caveats
    <<~EOS
      The Linux x86-64/arm64 and macOS arm64 lines are install-gated;
      macOS x86_64 is published with the same checksum verification.
      Docs: https://www.whitemagic.dev/whitemagic
    EOS
  end

  test do
    assert_match "wm #{version}", shell_output("#{bin}/wm --version")
  end
end
