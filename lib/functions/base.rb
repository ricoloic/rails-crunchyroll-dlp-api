module Functions
  class Base
    # @param method [String]
    def self.not_implemented(method)
      raise "method not implemented: #{method}"
    end
  end
end