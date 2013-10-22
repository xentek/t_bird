# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)
require 't_bird/version'

Gem::Specification.new do |gem|
  gem.name          = 't_bird'
  gem.version       = TBird::VERSION
  gem.authors       = ['Eric Marden']
  gem.email         = ['eric@xentek.net']
  gem.description   = %q{Straight forward file uploads for Ruby Apps.}
  gem.summary       = %q{Straight forward file uploads for Ruby Apps.}
  gem.homepage      = 'https://github.com/xentek/t_bird'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'mini_magick'
  gem.add_dependency 'aws-s3'
  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'gem-release'
end
