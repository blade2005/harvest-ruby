# frozen_string_literal: true

require_relative 'lib/harvest/version'

Gem::Specification.new do |spec|
  spec.name          = 'harvest-ruby-v2'
  spec.version       = Harvest::VERSION
  spec.authors       = ['Craig Davis']
  spec.email         = ['craig.davis@rackspace.com']

  spec.summary       = 'Fluent API Harvest Client API v2 '
  spec.description   = 'Harvest API for v2  written in Fluent API style'
  spec.homepage      = 'https://github.com/blade2005/harvest-ruby/wiki'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # spec.metadata['allowed_push_host'] = 'TODO: Set to 'http://mygemserver.com''

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/blade2005/harvest-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/blade2005/harvest-ruby/blob/master/CHANGELOG.rst'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  # spec.bindir        = 'exe'
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'activesupport', '~> 6.0'
  spec.add_dependency 'rest-client', '~> 2.1'
end
