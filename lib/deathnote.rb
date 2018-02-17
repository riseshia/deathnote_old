require "yaml"

require "deathnote/version"
require "deathnote/configuration"
require "deathnote/watcher"

module Deathnote
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def start(&callback)
      unless block_given?
        raise "Give me block for hook."
      end
      watcher = Watcher.new(callback)

      candidates.each do |class_name, target_methods|
        watcher.patch_const(class_name, target_methods)
      end
    end

    private

    def candidates
      @candidates ||= YAML.load(File.read(config.candidate_path))
    end
  end
end
