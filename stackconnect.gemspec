# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'stackconnect'

Gem::Specification.new do |spec|
  spec.name          = "stackconnect"
  spec.version       = StackConnect.return_version
  spec.authors       = ["amirtcheva"]
  spec.email         = ["amirtcheva@gmail.com"]
  spec.summary       = %q{Ruby API for connecting to StackOverflow. }
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.rubyforge_project = "stackconnect"

  
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "rspec", "~> 2.6"
  spec.add_development_dependency "bundler", "~> 1.5.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "json", "~> 1.8.1"
  spec.add_dependency "thor"
end
