require 'fileutils'

module Functions
  module Orchestrations
    module Executions
      class RemoveLocalFiles < Functions::Orchestrations::Executions::Base
        def execute
          return true unless Dir.exist?(episode_dir)

          FileUtils.rm_r(episode_dir)
          !Dir.exist?(episode_dir)
        end

        def output
          @output ||= {
            **previous_execution.output,
            "#{handle}" => {}
          }
        end

        def handle
          Constants::Handles::REMOVE_LOCAL_FILES
        end
      end
    end
  end
end