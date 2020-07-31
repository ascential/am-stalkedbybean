
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stalkedbybean/version"

Gem::Specification.new do |spec|
  spec.name          = "stalkedbybean"
  spec.version       = Stalkedbybean::VERSION
  spec.authors       = ["Kavita Kalaichelvan", "Thomas Depierre"]
  spec.email         = ["kavita.kalaichelvan@ascential.com", "thomas.depierre@ascential.com"]

  spec.summary       = "Command line utility to deploy Elixir apps to AWS using Elastic Beanstalk"
  spec.description   = "You can deploy your Elixir app to AWS by running a few simple commands."
  spec.homepage      = "https://github.com/ascential/am-stalkedbybean"
  spec.license       = "BSD-3-Clause"
  spec.required_ruby_version = ">=2.4.2"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_dependency "thor"
  spec.add_dependency "aws-sdk-kms"
  spec.add_dependency "aws-sdk-iam"
  spec.add_dependency "aws-sdk-elasticbeanstalk"
end
