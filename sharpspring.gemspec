lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.add_dependency 'rest-client'
  spec.add_dependency 'json'
  spec.add_dependency 'jsonpath'
  spec.authors = ['Nick Bryant']
  spec.description = 'A Ruby interface to the Sharpspring API.'
  spec.email = %w(sbryant31@gmail.com)
  spec.files = %w(.yardopts CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md twitter.gemspec) + Dir['lib/**/*.rb']
  spec.homepage = 'http://github.com/sbryant31/sharpspring-ruby/'
  spec.licenses = %w(MIT)
  spec.name = 'sharpspring'
  spec.require_paths = %w(lib)
  spec.required_ruby_version = '>= 1.9.3'
  spec.summary = spec.description
  spec.version = "0.0.1"
end
