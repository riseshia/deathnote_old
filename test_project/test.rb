require "set"
require "deathnote"
require "yaml"
require "active_support"
require "active_support/core_ext"

class User
  def feed; end
  def unused_feed; end
  def self.food; end
  def self.unused_food; end

  class << self
    def singleton; end
    def unused_singleton; end
  end
end

module IncludedModule
  def included_method; end
  def unused_included_method; end
end

module ExtendedModule
  def extended_method; end
  def unused_extended_method; end
end

class Base
  include IncludedModule
  extend ExtendedModule
end

Deathnote.start do |called_method|
  puts "'#{called_method}' is called."
end

# Runtime
User.new.feed
User.food
User.new.feed
User.food
User.singleton

Base.new.included_method
Base.new.included_method
Base.extended_method
Base.extended_method
