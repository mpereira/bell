# encoding: utf-8

require File.expand_path('../lib/bell/version', __FILE__)

Gem::Specification.new do |s|
  s.name     = 'bell'
  s.version  = Bell::VERSION
  s.platform = Gem::Platform::RUBY
  s.author   = 'Murilo Pereira'
  s.email    = 'murilo@murilopereira.com'
  s.homepage = 'https://github.com/mpereira/bell'
  s.summary  = 'Tenha controle sobre as suas faturas de telefone da Embratel.'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency('cucumber', '1.1.0')
  s.add_development_dependency('rake', '0.9.2')
  s.add_development_dependency('rspec', '2.6.0')

  s.add_dependency('embratel', '1.1.2')
  s.add_dependency('fastercsv', '1.5.4') if RUBY_VERSION < '1.9'
  s.add_dependency('sequel', '3.27.0')
  s.add_dependency('sqlite3', '1.3.4')

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.executable   = 'bell'
end
