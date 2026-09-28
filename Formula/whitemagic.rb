class Whitemagic < Formula
  desc "Local-first memory and session continuity for AI agents"
  homepage "https://www.whitemagic.dev"
  version "9.2.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-macos-aarch64"
      sha256 "72c0fac85b0c1ad47ffd37c8fd9eb651ea268b9660e1b9f03902b6c28aadf6b9"
    end
    on_intel do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-macos-x86_64"
      sha256 "b5a30dc5165eab4edd261429f406d40568f78472cce436a552c64337ced1cd0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-linux-aarch64-musl"
      sha256 "adb7723dd8d9a13bc98b5889dabfd5ab7588b5a0d6c557575d5316cb0514ca48"
    end
    on_intel do
      url "https://github.com/lbailey94/whitemagic/releases/download/v#{version}/wm-linux-x86_64-musl"
      sha256 "f03f682af0c3d187408b9dddb6464601ee63a13fe88aefa922df7da07c6def8b"
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
