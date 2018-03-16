
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stalkedbybean/version"

Gem::Specification.new do |spec|
  spec.name          = "stalkedbybean"
  spec.version       = Stalkedbybean::VERSION
  spec.authors       = ["Kavita Kalaichelvan", "Thomas Depierre"]
  spec.email         = ["kavita.kalaichelvan@ascential.com", "thomas.depierre@ascential.com"]

  spec.summary       = "CLI to deploy Elixir apps to AWS using Elastic Beanstalk"
  spec.description   = "You can deploy your Elixir app to AWS by running a few simple commands."
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "BSD-3-Clause"

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
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_dependency "thor"
end
