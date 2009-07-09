# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{condition_builder}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Hoeg", "Northwind Technologies Pte Ltd"]
  s.date = %q{2009-07-09}
  s.email = %q{peter@hoeg.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "lib/condition_builder.rb",
     "spec/condition_builder_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/peterhoeg/condition_builder}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{condition_builder}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{This gem assists in creating conditions and criteria for use in ActiveRecord .find statements.}
  s.test_files = [
    "spec/condition_builder_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
