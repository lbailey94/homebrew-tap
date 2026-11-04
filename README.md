# WhiteMagic Homebrew tap

```bash
brew tap lbailey94/tap
brew install whitemagic
```

This formula selects **stable Gen2 9.3.4**, with checksums for Linux x86-64/ARM64
and macOS Intel/ARM64. Stable release evidence records Linux and macOS ARM install
gates; the tap's own install/initialize/tools-list/uninstall matrix is a new CI
candidate and must run before claiming qualification on each formula platform.
macOS Intel remains published without that install qualification.

`bash test/check-release.sh` compares all four formula hashes with the exact
GitHub release API digests. `ruby -c Formula/whitemagic.rb` checks syntax. Metadata
agreement is not binary download verification or installation evidence; Homebrew
verifies downloaded content during the separate install job.

[Setup](https://www.whitemagic.dev/install) ·
[Stable release](https://github.com/lbailey94/whitemagic/releases/tag/v9.3.4) ·
[Source](https://github.com/lbailey94/whitemagic)
