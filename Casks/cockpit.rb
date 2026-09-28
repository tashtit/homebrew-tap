cask "cockpit" do
  arch arm: "arm64", intel: "x64"

  version "0.57.1"
  sha256 arm:   "d4b73bce71bb368c58f6e4359d5c6a4cfdcd10c3c231b0222ab6c4bdf848392a",
         intel: "c5d5dcc947bac5c1184c9fbbfb694a3444258d55497bdb2319a8c572be0f7c26"

  url "https://github.com/tashtit/cockpit/releases/download/v#{version}/Cockpit-#{version}-#{arch}.dmg"
  name "Cockpit"
  desc "Desktop hub for Claude Code, Codex and Copilot CLI sessions"
  homepage "https://tashtit.github.io/cockpit/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Cockpit installs its own updates from GitHub Releases
  auto_updates true
  depends_on macos: :ventura

  app "Cockpit.app"

  # Releases are not signed with an Apple Developer ID yet, and macOS refuses to open
  # an unsigned app that carries the quarantine flag Homebrew's download leaves on it.
  # The download itself was checked against sha256 above.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Cockpit.app"],
        must_succeed:   false,
        writable_paths: ["Cockpit.app"],
        writable_base:  :appdir
  end

  zap trash: [
    "~/Library/Application Support/Cockpit",
    "~/Library/Caches/Cockpit",
    "~/Library/Logs/Cockpit",
    "~/Library/Preferences/dev.tashtit.cockpit.plist",
    "~/Library/Saved Application State/dev.tashtit.cockpit.savedState",
  ]
end
