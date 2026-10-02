cask "cockpit" do
  arch arm: "arm64", intel: "x64"

  version "0.57.4"
  sha256 arm:   "2b4301549e9e8b90addc51324f9e5424f69b18beac87be52804e0b6338d8ab58",
         intel: "b29b5f79f7f874ef04a9b37a20895c86942dfdfb62ef34a4df92e2f67fa38c63"

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
