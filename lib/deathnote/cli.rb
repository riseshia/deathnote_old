# frozen_string_literal: true

require "optparse"
require "yaml"

require "deathnote/method_processor"

module Deathnote
  class CLI
    # @return [Integer] UNIX exit code
    def run
      options = Parser.parse
      targets = Deathnote::MethodProcessor.new.run(candidate_paths(options))
      targets.keys.each do |key|
        targets[key] = targets[key].to_a
      end

      File.open(options.output_path, "w") do |f|
        f.write(targets.to_yaml)
      end

      0
    end

    private

    def candidate_paths(options)
      excluded_paths = options.excluded_paths
      Dir["**/*.rb"].reject do |path|
        excluded_paths.any? { |ex| path.include?(ex) }
      end
    end

    Options = Struct.new(:excluded_paths, :output_path)

    class Parser
      def self.parse
        args = Options.new([], "candidate.yml")

        optparser = OptionParser.new do |opts|
          opts.banner = "Usage: deathnote [options]"

          opts.on("-ex", "--excluded_paths=PATH1,PATH2", "Path not to want to included") do |paths|
            args.excluded_paths = paths.split(",")
          end

          opts.on("-o", "--output_path=candidate.yml", "Path which result will be written.") do |path|
            args.output_path = path
          end

          opts.on("-h", "--help", "Prints this help") do
            puts opts
            exit
          end
        end
        optparser.parse!
        args
      end
    end
  end
end
