# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dirty_history}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gavin Todes"]
  s.date = %q{2011-05-01}
  s.description = %q{Dirty History is a simple gem that allows you to keep track of changes to specific fields in your Rails models using the ActiveRecord::Dirty module.}
  s.email = %q{gavin.todes@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "dirty_history.gemspec",
    "init.rb",
    "lib/dirty_history.rb",
    "lib/dirty_history/dirty_history_mixin.rb",
    "lib/dirty_history/dirty_history_record.rb",
    "lib/generators/dirty_history/migration/migration_generator.rb",
    "lib/generators/dirty_history/migration/templates/active_record/migration.rb",
    "rails/init.rb",
    "test/helper.rb",
    "test/test_dirty_history.rb"
  ]
  s.homepage = %q{http://github.com/GAV1N/dirty_history}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Easily keep track of changes to specific model fields.}
  s.test_files = [
    "test/helper.rb",
    "test/test_dirty_history.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

