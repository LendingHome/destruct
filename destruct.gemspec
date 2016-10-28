Gem::Specification.new do |s|
  s.author                = "LendingHome"
  s.email                 = "github@lendinghome.com"
  s.extra_rdoc_files      = %w(LICENSE)
  s.files                 = `git ls-files`.split("\n")
  s.homepage              = "https://github.com/lendinghome/destruct"
  s.license               = "MIT"
  s.name                  = "destruct"
  s.rdoc_options          = %w(--charset=UTF-8 --inline-source --line-numbers --main README.md)
  s.require_paths         = %w(lib)
  s.required_ruby_version = ">= 2.3.0"
  s.summary               = "ES6 style object destructuring in Ruby"
  s.test_files            = `git ls-files -- spec/*`.split("\n")
  s.version               = "0.0.0"
end
