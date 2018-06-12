module Rql
  class PathBuilder
    def initialize(path = nil)
      @path = path || []
    end

    def to_h
      path_hash = nil
      @path.reverse_each do |name|
        path_hash = path_hash ? {name.to_sym => path_hash} : name.to_sym
      end
      path_hash
    end

    def method_missing(name)
      PathBuilder.new(@path.concat([name.to_sym]))
    end
  end
end