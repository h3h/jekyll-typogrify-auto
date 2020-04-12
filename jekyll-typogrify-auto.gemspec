# frozen_string_literal: true

require_relative 'lib/jekyll_typogrify_auto/version'

Gem::Specification.new do |s|
  s.name        = 'jekyll-typogrify-auto'
  s.summary     = 'Automatic typogrify support for your Jekyll content.'
  s.version     = JekyllTypogrifyAuto::VERSION
  s.authors     = ['Bradford Fults']
  s.email       = 'bfults@gmail.com'

  s.homepage    = 'https://github.com/h3h/jekyll-typogrify-auto'
  s.licenses    = ['MIT']
  s.files       = ['lib/jekyll-typogrify-auto.rb']

  s.add_dependency 'html-pipeline', '~> 2.12'
  s.add_dependency 'jekyll',        '~> 4.0'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake', '>= 12.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rubocop-jekyll', '~> 0.4'
end
