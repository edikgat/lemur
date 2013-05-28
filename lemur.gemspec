# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lemur/version'

Gem::Specification.new do |spec|
  spec.name          = "lemur"
  spec.version       = Lemur::VERSION
  spec.authors       = ["Eduard Gataullin"]
  spec.email         = ["edikgat@gmail.com"]
  spec.description   = %q{Lemur is a lightweight, flexible Ruby SDK for Odnoklassniki.  It allows read/write access to Odnoklassniki API. To work with Lemur you need VALUABLE ACCESS to odnoklassniki api. This api work only with access_token that gives you odnoklassniki, when you authorize with omniauth.}
  spec.summary       = %q{Api for www.odnoklassniki.ru }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency("faraday")
end
