$:.unshift File.expand_path('../lib', __FILE__)
require 'routing_filter/version'

Gem::Specification.new do |s|
  s.name         = "routing-filter"
  s.version      = RoutingFilter::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "svenfuchs@artweb-design.de"
  s.homepage     = "http://github.com/svenfuchs/routing-filter"
  s.summary      = "Routing filters wraps around the complex beast that the Rails routing system is, allowing for unseen flexibility and power in Rails URL recognition and generation"
  s.description  = "Routing filters wraps around the complex beast that the Rails routing system is, allowing for unseen flexibility and power in Rails URL recognition and generation."

  s.files        = `git ls-files {app,lib}`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  set the dep version of Rails stuff to ~> 2.3.5 so we dont pull down Rails 3
  s.add_dependency 'actionpack', '~> 2.3.5'
  
  # i18n is vendored in activesupport ~> 2.3, leaving this in will pull in Rails 3 stuff
  # s.add_development_dependency 'i18n' 
  s.add_development_dependency 'rails', '~> 2.3.5'
  s.add_development_dependency 'test_declarative'
end
