# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/middleware/query_tracer/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-middleware-query_tracer"
  spec.version       = Rack::Middleware::QueryTracer::VERSION
  spec.authors       = ["Keiichiro Nagano"]
  spec.email         = ["knagano@CPAN.org"]
  spec.summary       = %q{Dumps SQL queries with their positions in the source code}
  spec.description   = %q{Dumps SQL queries with their positions in the source code}
  spec.homepage      = "https://github.com/knagano/rack-middleware-query_tracer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "arproxy", "~> 0.2.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
