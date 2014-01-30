require 'rubygems'
spec = Gem::Specification.new do |s|
  s.name = "hiera-puppet"
  s.version = '1.0'
  s.author = "Puppet Labs"
  s.email = "info@puppetlabs.com"
  s.homepage = "https://github.com/puppetlabs/hiera-puppet"
  s.platform = Gem::Platform::RUBY
  s.summary = "Puppet query interface and backend for Hiera"
  s.description = "Store and query Hiera data from Puppet"
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["spec/**/*.rb"].to_a
  s.has_rdoc = true
  s.add_dependency 'hiera', '~> 1.0'
  s.executables = "extlookup2hiera"
end

