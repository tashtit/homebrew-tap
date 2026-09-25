cask "cockpit" do
  arch arm: "arm64", intel: "x64"

  version "0.44.0"
  sha256 arm:   "db4e6a77e0060e1b1b0f958b2812ecf7352069919deff37a8328757f8e09b062",
         intel: "406e49a7e26e98fdc67bef1324a0735bf3251c051e2485b5c9a8bbb1d492e899"

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
