# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spreadsheet_goodies/version'

Gem::Specification.new do |gemspec|
  gemspec.name = 'spreadsheet_goodies'
  gemspec.version = SpreadsheetGoodies::VERSION
  gemspec.authors = ['Ricardo Jasinski']
  gemspec.email = ['jasinski@solvis.com.br']

  gemspec.summary = "SpreadsheetGoodies is a collection of tools to help work " +
    "with Excel and Google Drive spreadhseets."
  gemspec.description = "SpreadsheetGoodies is a collection of tools to help work " +
    "with Excel and Google Drive spreadhseets. It relies " +
    "on other gems to do the actual work of reading and writing to " +
    "spreadsheet documents. It main features are:"
    "  * Read a spreadseet to an array of arrays, to allow accessing its data " +
    "    without using the original document"
    "  * Access a row's elements using the column titles as keys"
  gemspec.homepage = 'https://github.com/ricardo-jasinski/spreadsheet_goodies'
  gemspec.license = 'Unlicense'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if gemspec.respond_to?(:metadata)
    gemspec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  gemspec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  gemspec.bindir = 'exe'
  gemspec.executables = gemspec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gemspec.require_paths = ['lib']

  gemspec.add_development_dependency 'bundler', '~> 1.14'
  gemspec.add_development_dependency 'rake', '~> 10.0'
  gemspec.add_development_dependency 'rspec', '~> 3.0'

  gemspec.add_dependency 'axlsx', '~> 0'
  gemspec.add_dependency 'google_drive', '~> 0'
  gemspec.add_dependency 'csv', '~> 0'
  gemspec.add_dependency 'roo', '~> 0' #, '~> 2.7.1'
  gemspec.add_dependency 'roo-xls', '~> 0'

end