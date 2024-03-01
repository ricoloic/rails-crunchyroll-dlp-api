module Controls
  class Base
    # @param command [String]
    # @param arguments [Array<String>]
    # @return [TrueClass, FalseClass] true when exit code is 0, false otherwise
    def self.exec(command, arguments)
      pp command
      pp arguments
      success = Kernel.system(command, *arguments)
      return false if success.nil?
      success
    end
  end
end