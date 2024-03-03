module Controls
  class Base
    # @param command [String]
    # @param arguments [Array<String>]
    # @return [Boolean] true when exit code is 0, false otherwise
    def self.execute_command(command, arguments)
      pp command
      pp arguments
      success = Kernel.system(command, *arguments)
      return false if success.nil?
      !!success
    end
  end
end