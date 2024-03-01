require 'fileutils'

module Functions
  module Executions
    class RemoveLocalFiles < Functions::Executions::Base
      def initialize(episode:, previous_execution:)
        super(handle: Constants::ExecutionProcessHandles::REMOVE_LOCAL_FILES, episode:, previous_execution:)
      end

      def self.start(episode:, previous_execution:)
        new(episode:, previous_execution:).start
      end

      def self.init(episode:, previous_execution:)
        new(episode:, previous_execution:).init
      end

      def init
        self
      end

      def start
        create_dirs
        run

        if exec
          complete
        else
          fail
        end
      end

      def exec
        return true unless Dir.exist?(@dir)

        FileUtils.rm_r(@dir)
        !Dir.exist?(@dir)
      end

      def filename
        @filename ||= previous_execution.output[Constants::ExecutionProcessHandles::DOWNLOAD_VIDEO]["filename"]
      end

      def output
        @output ||= {
          **previous_execution.output,
          "#{@handle}" => {
            "path" => @season_dir.join(filename).to_s,
            "filename" => filename
          }
        }
      end
    end
  end
end