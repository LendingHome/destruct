require_relative "destruct/dig"
require_relative "destruct/hash"
require_relative "destruct/object"

module Destruct
  ::Object.send(:include, Object)
  GEMSPEC = File.expand_path("../../destruct.gemspec", __FILE__)
  VERSION = Gem::Specification.load(GEMSPEC).version.to_s
end
