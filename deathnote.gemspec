
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "deathnote/version"

Gem::Specification.new do |spec|
  spec.name          = "deathnote"
  spec.version       = Deathnote::VERSION
  spec.authors       = ["Shia"]
  spec.email         = ["rise.shia@gmail.com"]

  spec.summary       = %q{logging unused methods in execution.}
  spec.description   = %q{Deathnote will log all methods in the project, which methods wasn't called in exection.}
  spec.homepage      = "https://github.com/riseshia/deathnote"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "benchmark-ips", "~> 2.7.2"
  spec.add_development_dependency "okuribito", "~> 0.2.3"
  spec.add_dependency "activesupport", ">= 4.0"
  spec.add_dependency "ruby_parser", "~> 3.11.0"
  spec.add_dependency "sexp_processor", "~> 4.10.1"
end
