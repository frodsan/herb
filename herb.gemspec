Gem::Specification.new do |s|
  s.name        = "herb"
  s.version     = "0.0.1"
  s.summary     = %q(ERB-like template engine that escapes HTML by default)
  s.description = s.summary
  s.author      = "Francesco Rodriguez"
  s.email       = "frodsan@protonmail.com"
  s.homepage    = "https://github.com/frodsan/herb"
  s.license     = "MIT"

  s.files      = Dir["LICENSE", "README.md", "lib/**/*.rb"]
  s.test_files = Dir["test/**/*.rb"]

  s.add_development_dependency "minitest", "~> 5.8"
  s.add_development_dependency "minitest-sugar", "~> 2.1"
  s.add_development_dependency "rake", "~> 11.0"
  s.add_development_dependency "rubocop", "~> 0.39"
end
