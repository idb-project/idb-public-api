require 'yaml'
require 'pathname'
require 'idb/config'

module IDB
  class ConfigFile
    FileNotFound = Class.new(StandardError)

    PATHS = [
      Pathname.new('/etc/idb-public-api/config.yml'),
      Pathname.new('./config.yml').expand_path
    ]

    def self.load(filename = nil)
      filename ||= PATHS.find {|p| p.exist? }
      path = Pathname.new(filename).expand_path

      unless path.exist?
        raise FileNotFound, "Config file #{path} does not exist."
      end

      IDB::Config.new(YAML.load_file(path))
    end
  end
end
