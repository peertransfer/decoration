Gem::Specification.new do |spec|
  spec.name        = 'decoration'
  spec.version     = '0.0.1'
  spec.date        = '2016-05-03'
  spec.summary     = 'A mixin for make an object a decorator'
  spec.description = 'A mixin for make an object a decorator'
  spec.authors     = ['Flywire tech']
  spec.email       = ['tech@peertransfer.com']
  spec.files       = ['lib/decoration.rb']
  spec.homepage    = 'http://github.com/peertransfer/decoration'
  spec.license     = 'MIT'

  spec.add_development_dependency 'bundler', '>= 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'coveralls'
end
