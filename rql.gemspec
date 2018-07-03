
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rql/version"

Gem::Specification.new do |spec|
  spec.name          = "rql"
  spec.version       = Rql::VERSION
  spec.authors       = ["Lief Nikkel"]
  spec.email         = ["lief.nikkel@youdo.co.nz"]

  spec.summary       = "A DSL for Active Record Queries"
  spec.description   = "RQL is a DSL that allows derived attributes in Active Record models to be used in database queries"
  spec.homepage      = "https://github.com/liefni/rql"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard-activesupport-concern"

  spec.add_runtime_dependency "activerecord", ">= 5.0"
end
