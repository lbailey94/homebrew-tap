class Whitemagic < Formula
  desc "Local-first memory and session continuity for AI agents"
  homepage "https://www.whitemagic.dev"
  version "9.2.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-macos-aarch64"
      sha256 "9270b6d8db611ba1246bb01b6e3fd794b6e670c9a6bf4fd5a8065922ba0f5962"
    end
    on_intel do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-macos-x86_64"
      sha256 "a70f79b78bda00fce747604b1392ccaacab95fcbf56c4a416ed3fc5481e78765"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-linux-aarch64-musl"
      sha256 "d46e92fc38f55b5cfe05d8baf99993cf70d663d9aa5d8855994c99b0a014e053"
    end
    on_intel do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-linux-x86_64-musl"
      sha256 "5c20f42cd7a0645b79104a18b08bf8754f5fdaf42b3138951a4e05a9835a2802"
    end
  end

  def install
    binary = Dir["wm-*"].first
    odie "release asset missing from the download" if binary.nil?
    bin.install binary => "wm"
  end

  def caveats
    <<~EOS
      The Linux x86-64/arm64 lines are install-gated; macOS binaries are
      published but not install-gated. Docs: https://www.whitemagic.dev/whitemagic
    EOS
  end

  test do
    assert_match "wm #{version}", shell_output("#{bin}/wm --version")
  end
end
