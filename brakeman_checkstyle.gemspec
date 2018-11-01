
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "brakeman_checkstyle/version"

Gem::Specification.new do |spec|
  spec.name          = "brakeman_checkstyle"
  spec.version       = BrakemanCheckstyle::VERSION
  spec.authors       = ["rnitta"]
  spec.email         = ["attinyes@gmail.com"]

  spec.summary       = %q{Format Brakeman output to checkstyle}
  spec.description   = %q{That's it}
  spec.homepage      = "https://github.com/rnitta/brakeman_checkstyle"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'brakeman'
  spec.add_dependency 'thor'
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
