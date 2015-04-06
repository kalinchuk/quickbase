Gem::Specification.new do |s|
  s.name = %q{quickbase}
  s.version = "0.0.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Artem Kalinchuk"]
  s.date = %q{2012-07-06}
  s.description = %q{The Quickbase Gem provides integration access to the Intuit Quickbase API.}
  s.email = %q{artem9@gmail.com}
  s.files = ["lib/quickbase.rb", "quickbase.gemspec", "README.rdoc", "lib/classes/api.rb", "lib/classes/connection.rb", "lib/classes/helper.rb", "lib/classes/http.rb", "spec/quickbase_spec.rb"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Quickbase"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{quickbase}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Quickbase Ruby Gem}
  s.add_dependency(%q<nokogiri>, [">= 0"])
  s.add_dependency(%q<httparty>, [">= 0"])
  s.add_dependency(%q<activesupport>, [">= 0"])
end
