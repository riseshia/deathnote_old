require "pathname"
require "logger"

module Deathnote
  class Configuration
    attr_accessor :candidate_path

    def initialize
      @candidate_path = "candidate.yml"
    end
  end
end
