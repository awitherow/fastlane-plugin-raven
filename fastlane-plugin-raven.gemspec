# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/raven/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-raven'
  spec.version       = Fastlane::Raven::VERSION
  spec.author        = "Marten Klitzke"
  spec.email         = "me@mortik.xyz"

  spec.summary       = "Plugin to manage Releases and upload JS Sourcemaps"
  spec.homepage      = "https://github.com/mortik/fastlane-plugin-raven"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'typhoeus', '~> 1.0', '>= 1.0.0'

  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'bundler', '~> 0'
  spec.add_development_dependency 'rspec', '~> 0'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'rubocop', '~> 0'
  spec.add_development_dependency 'fastlane', '~> 2.23', '>= 2.23.0'
end
