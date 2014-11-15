# encoding: utf-8
path = "../../public/assets/manifest.json"
MANIFEST_PATH = File.expand_path(File.join(File.dirname(__FILE__), path))

if %w(staging production).include?(ENV["RACK_ENV"])
  data = MultiJson.load File.read(MANIFEST_PATH)
  ASSETS_PATH = data["assets"]
end
