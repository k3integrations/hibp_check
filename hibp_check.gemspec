lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hibp_check/version"

Gem::Specification.new do |spec|
  spec.name          = "hibp_check"
  spec.version       = HibpCheck::VERSION
  spec.authors       = ["John Ash"]
  spec.email         = ["john.ash@k3integrations.com"]

  spec.summary       = %q{Check passwords against API of compromised passwords}
  spec.description   = %q{Check passwords against API of compromised passwords}
  spec.homepage      = "https://github.com/k3integrations/hibp_check"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    [
      'LICENSE.txt',
      'hibp_check.gemspec',
      'lib/hibp_check.rb',
      'lib/hibp_check/version.rb'
    ]
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "webmock", "~> 3.5"
end
