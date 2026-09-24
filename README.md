# Homebrew tap for Cockpit

[Cockpit](https://github.com/tashtit/cockpit) is a macOS desktop hub for Claude Code,
Codex and GitHub Copilot CLI sessions.

```bash
brew install --cask tashtit/tap/cockpit
```

Cockpit updates itself after that, so `brew upgrade` has nothing to do for it.
`brew uninstall --zap --cask cockpit` also removes its settings.

## How this tap works

- `Casks/cockpit.rb` points at the disk images on
  [Cockpit's releases](https://github.com/tashtit/cockpit/releases), each checked against
  the sha256 digest GitHub recorded when the release workflow uploaded it.
- Releases are not signed with an Apple Developer ID yet, so the cask clears the
  quarantine flag after install. Without that, macOS would refuse the first launch.
- [`bump.yml`](.github/workflows/bump.yml) checks for a new release every hour and
  commits the new version and digests to `main`. GitHub pauses scheduled workflows in a
  repository with no activity for 60 days; if that happens, re-enable it from the
  Actions tab (or run it by hand).
