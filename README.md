# WhiteMagic Homebrew tap

```bash
brew tap lbailey94/tap
brew install whitemagic
```

This formula selects **stable Gen2 9.3.4**, with checksums for Linux x86-64/ARM64
and macOS Intel/ARM64. On November 4, 2026, the tap's actual install, version check,
formula test, MCP create/read/process-restart/read and uninstall controls passed
on Ubuntu 24.04 x86-64/ARM64 and macOS 26 Intel/ARM64. The run used source
`dda2b4cee93e867b687fa595ee81b5ff11d51346` and these unchanged 9.3.4 artifacts:
[five successful CI jobs](https://github.com/lbailey94/homebrew-tap/actions/runs/41891249591).
This qualifies the tested release on those runner images; other OS versions,
host configurations, receipt attestation and hosted-service behavior require
their own evidence.

`bash test/check-release.sh` compares all four formula hashes with the exact
GitHub release API digests. `ruby -c Formula/whitemagic.rb` checks syntax. Metadata
agreement is not binary download verification or installation evidence; Homebrew
verifies downloaded content during the separate install job.

[Setup](https://www.whitemagic.dev/install) ·
[Stable release](https://github.com/lbailey94/whitemagic/releases/tag/v9.3.4) ·
[Source](https://github.com/lbailey94/whitemagic)
