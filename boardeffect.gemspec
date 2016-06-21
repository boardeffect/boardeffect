# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boardeffect/version'

Gem::Specification.new do |spec|
  spec.name             = "boardeffect"
  spec.version          = BoardEffect::VERSION
  spec.authors          = ['Mark Hunt']
  spec.email            = ['development@boardeffect.com']
  spec.homepage         = 'https://github.com/magicmarkker/boardeffect'
  spec.description      = 'Ruby client for Version 2 of the BoardEffect API'
  spec.summary          = 'Ruby client for Version 2 of the BoardEffect API'
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'webmock', '~> 1.24'
  spec.add_development_dependency 'minitest', '~> 5.0'
end