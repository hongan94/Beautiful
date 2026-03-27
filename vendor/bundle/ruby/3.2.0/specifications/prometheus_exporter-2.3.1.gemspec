# -*- encoding: utf-8 -*-
# stub: prometheus_exporter 2.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "prometheus_exporter".freeze
  s.version = "2.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sam Saffron".freeze]
  s.bindir = "exe".freeze
  s.date = "2025-11-12"
  s.description = "Prometheus metric collector and exporter for Ruby".freeze
  s.email = ["sam.saffron@gmail.com".freeze]
  s.executables = ["prometheus_exporter".freeze]
  s.files = ["exe/prometheus_exporter".freeze]
  s.homepage = "https://github.com/discourse/prometheus_exporter".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.2.0".freeze)
  s.rubygems_version = "3.4.19".freeze
  s.summary = "Prometheus Exporter".freeze

  s.installed_by_version = "3.4.19" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<webrick>.freeze, [">= 0"])
end
