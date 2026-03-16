# frozen_string_literal: true

require_relative 'lib/legion/extensions/mood/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-mood'
  spec.version       = Legion::Extensions::Mood::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Mood'
  spec.description   = 'Persistent mood state that emerges from emotional patterns and biases cognitive processing'
  spec.homepage      = 'https://github.com/LegionIO/lex-mood'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/LegionIO/lex-mood'
  spec.metadata['documentation_uri'] = 'https://github.com/LegionIO/lex-mood'
  spec.metadata['changelog_uri'] = 'https://github.com/LegionIO/lex-mood'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/LegionIO/lex-mood/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-mood.gemspec Gemfile LICENSE README.md]
  end
  spec.require_paths = ['lib']
  spec.add_development_dependency 'legion-gaia'
end
