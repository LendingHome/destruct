require_relative "destruct/dsl"
require_relative "destruct/hash"
require_relative "destruct/object"
require_relative "destruct/resolver"

Object.send(:include, Destruct::Object)

class Destruct
  GEMSPEC = File.expand_path("../../destruct.gemspec", __FILE__)
  VERSION = Gem::Specification.load(GEMSPEC).version.to_s

  def initialize(object, *paths, &block)
    @object = object
    @paths = paths
    @block = block || proc { }
  end

  def dsl
    DSL.new(&@block)
  end

  def paths
    @paths + dsl.paths
  end

  def resolve(path)
    Resolver.new(@object, path).to_h
  end

  def to_h
    paths.each_with_object(Hash.new) do |path, hash|
      resolve(path).each do |key, value|
        hash[key] = value
      end
    end
  end
end
