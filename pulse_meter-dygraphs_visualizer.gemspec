# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Ilya Averyanov", "Sergey Averyanov"]
  gem.email         = ["av@fun-box.ru", "averyanov@gmail.com"]
  gem.description   = %q{Customizable web interface for PulseMeter gem}
  gem.summary       = %q{
    Customizable Dygraphs-based web interface for lightweight metrics aggregator and processor PulseMeter
  }
  gem.homepage      = "https://github.com/savonarola/pulse_meter-dygraphs_visualizer"

  gem.required_ruby_version = '>= 1.9.2'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pulse_meter-dygraphs_visualizer"
  gem.require_paths = ["lib"]
  gem.version       = "0.4.23"

  gem.add_runtime_dependency('pulse_meter_core')
  gem.add_runtime_dependency('gon-sinatra')
  gem.add_runtime_dependency('haml')
  gem.add_runtime_dependency('sinatra')
  gem.add_runtime_dependency('sinatra-partial')

  gem.add_development_dependency('aquarium')
  gem.add_development_dependency('foreman')
  gem.add_development_dependency('hashie')
  gem.add_development_dependency('listen')
  gem.add_development_dependency('mock_redis')
  gem.add_development_dependency('rack-test')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rb-fsevent')
  gem.add_development_dependency('redcarpet')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('simplecov')
  gem.add_development_dependency('timecop')
  gem.add_development_dependency('yard')

end
