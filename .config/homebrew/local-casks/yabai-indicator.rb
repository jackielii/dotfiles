cask "yabai-indicator" do
  version "0.3.4"
  sha256 "5dde182daebe3f442193232d3cdefbd66364235c7fa0490bbc5e67f42e1912ef"

  url "https://github.com/xiamaz/YabaiIndicator/releases/download/#{version}/YabaiIndicator-#{version}.zip"
  name "Yabai Indicator"
  desc "Menu bar spaces and window indicator for yabai"
  homepage "https://github.com/xiamaz/YabaiIndicator"

  app "YabaiIndicator-#{version}/YabaiIndicator.app"
end
