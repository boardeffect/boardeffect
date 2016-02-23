Gem::Specification.new do |s|
  s.name = 'boardeffect'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Mark Hunt']
  s.email = ['development@boardeffect.com']
  s.homepage = 'http://github.com/magicmarkker/boardeffect'
  s.description = 'Ruby client for Version 2 of the BoardEffect API'
  s.summary = 'Ruby client for Version 2 of the BoardEffect API'
  s.files = Dir.glob('{lib,spec}/**/*') + %w(LICENSE.txt README.md boardeffect.gemspec)
  s.required_ruby_version = '>= 2.0.0'
  s.add_development_dependency('rake', '~> 10.4')
  s.add_development_dependency('webmock', '~> 1.24')
  s.add_development_dependency('minitest', '~> 5.0')
  s.require_path = 'lib'
end