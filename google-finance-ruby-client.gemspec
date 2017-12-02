$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'google-finance/version'

Gem::Specification.new do |s|
  s.name = 'google-finance-ruby-client'
  s.bindir = 'bin'
  s.version = GoogleFinance::VERSION
  s.authors = ['Daniel Doubrovkine']
  s.email = 'dblock@dblock.org'
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = '>= 1.3.6'
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ['lib']
  s.homepage = 'http://github.com/dblock/google-finance-ruby-client'
  s.licenses = ['MIT']
  s.summary = 'Google Finance web API ruby client.'
  s.add_development_dependency 'rake', '~> 10'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop', '0.51.0'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
