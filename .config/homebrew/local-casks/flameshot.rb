cask "flameshot" do
  arch arm: "arm64", intel: "intel"
  version "14.0.0,14.0"
  sha256 arm: "bb0cccb2223ce0f4bfea00d90658e85fb5dc17aa7773bf2b22c70ffdb23d7221",
         intel: "871653260d9298db2e2a85e121c514f753dfdca94dccabbd74c142a2438f3d78"

  url "https://github.com/flameshot-org/flameshot/releases/download/v#{version.csv.first}/Flameshot-#{version.csv.second}-macos-#{arch}.dmg"
  name "Flameshot"
  desc "Screenshot software with built-in annotation tools"
  homepage "https://flameshot.org/"
  depends_on macos: :sequoia
  app "Flameshot.app"
  uninstall quit: "org.flameshot.flameshot"
end
