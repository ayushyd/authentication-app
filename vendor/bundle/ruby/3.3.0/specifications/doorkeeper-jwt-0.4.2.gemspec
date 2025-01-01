# -*- encoding: utf-8 -*-
# stub: doorkeeper-jwt 0.4.2 ruby lib

Gem::Specification.new do |s|
  s.name = "doorkeeper-jwt".freeze
  s.version = "0.4.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chris Warren".freeze, "Nikita Bulai".freeze]
  s.bindir = "exe".freeze
  s.date = "2024-08-12"
  s.description = "JWT token generator extension for Doorkeeper".freeze
  s.email = ["chris@expectless.com".freeze]
  s.homepage = "https://github.com/chriswarren/doorkeeper-jwt".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "JWT token generator for Doorkeeper".freeze

  s.installed_by_version = "3.6.1".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<jwt>.freeze, [">= 2.1".freeze])
  s.add_development_dependency(%q<bundler>.freeze, [">= 1.16".freeze, "< 3".freeze])
  s.add_development_dependency(%q<pry>.freeze, ["~> 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.8".freeze])
end
