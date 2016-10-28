require_relative "destruct/dig"
require_relative "destruct/hash"
require_relative "destruct/object"

Object.send(:include, Destruct::Object)

module Destruct
  GEMSPEC = name.downcase.concat(".gemspec")

  class << self
    def gemspec
      @gemspec ||= Gem::Specification.load(root.join(GEMSPEC).to_s)
    end

    def root
      @root ||= Pathname.new(__FILE__).dirname.dirname
    end

    def version
      gemspec.version.to_s
    end
  end
end
