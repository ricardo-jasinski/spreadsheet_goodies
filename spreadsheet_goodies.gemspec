# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spreadsheet_goodies/version'

Gem::Specification.new do |gemspec|
  gemspec.name = 'spreadsheet_goodies'
  gemspec.version = SpreadsheetGoodies::VERSION
  gemspec.authors = ['Ricardo Jasinski', 'Henrique Gubert']
  gemspec.email = ['jasinski@solvis.com.br', 'guberthenrique@hotmail.com']

  gemspec.summary = "SpreadsheetGoodies is a collection of tools to help work " +
    "with Excel and Google Drive spreadsheets."
  gemspec.description = "SpreadsheetGoodies is a collection of tools to help work " +
    "with Excel and Google Drive spreadsheets. It relies " +
    "on other gems to do the actual work of reading and writing to " +
    "spreadsheet documents. It main features are:"
    "  * Read a spreadseet to an array of arrays, to allow accessing its data " +
    "    without using the original document/file/object"
    "  * Access a row's elements using the column titles as keys"
  gemspec.homepage = 'https://github.com/ricardo-jasinski/spreadsheet_goodies'
  gemspec.license = 'Unlicense'
  gemspec.metadata['allowed_push_host'] = 'https://rubygems.org'

  gemspec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  gemspec.bindir = 'exe'
  gemspec.executables = gemspec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gemspec.require_paths = ['lib']

  gemspec.add_development_dependency 'bundler', '~> 1.14'
  gemspec.add_development_dependency 'rake', '~> 10.0'
  gemspec.add_development_dependency 'rspec', '~> 3.0'

  gemspec.add_dependency 'axlsx', '>= 2.0.1'
  gemspec.add_dependency 'google_drive', '>= 2.1.5'
  gemspec.add_dependency 'csv', '>= 3.0.0'
  gemspec.add_dependency 'roo', '>= 1.13.2'

end
