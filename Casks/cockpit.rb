cask "cockpit" do
  arch arm: "arm64", intel: "x64"

  version "0.59.1"
  sha256 arm:   "88b6d956af4b75ee672ce6eb67a85c360c09aacaf7398dba17b3d3aa51533c56",
         intel: "0a61563880c34eaff9e8a14585c709cf0a38e98dda705a926cddb0eb27870fa7"

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
