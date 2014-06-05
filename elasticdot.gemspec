Gem::Specification.new do |s|
  s.name        = 'elasticdot'
  s.version     = '1.0'
  s.date        = '2014-05-10'
  s.summary     = "ElasticDot CLI"
  s.description = "ElasticDot Command Line Interface"
  s.authors     = ["ElasticDot"]
  s.email       = 'info@elasticdot.com'
  s.homepage    = 'http://elasticdot.com'
  s.license     = 'MIT'
  s.executables = 'elasticdot'

  s.files       = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(License|README|bin/|lib/)} }

  s.add_dependency "netrc",          "~> 0.7.7"
  s.add_dependency "rest-client",    "~> 1.6.1"
end
