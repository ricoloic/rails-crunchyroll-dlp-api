module Functions
  module Executions
    class MergeAudioStreams < Functions::Executions::Base
      def initialize(episode:, previous_execution:)
        super(handle: Constants::ExecutionProcessHandles::MERGE_AUDIO_STREAMS, episode:, previous_execution:)
      end

      def self.start(episode:, previous_execution:)
        new(episode:, previous_execution:).start
      end

      def self.init(episode:, previous_execution:)
        new(episode:, previous_execution:).init
      end

      def init
        init_next
        self
      end

      def start
        create_dirs
        run

        if exec
          complete
          start_next
        else
          fail
        end
      end

      def init_next
        @next = Functions::Executions::Metadata.init(episode:, previous_execution: execution_process)
      end

      def start_next
        init_next if @next.blank?
        @next.start
      end

      def exec
        return true if output[Constants::ExecutionProcessHandles::DOWNLOAD_VIDEO]["uploaded"]

        return true if Pathname.new(output[@handle]["path"]).exist?

        Controls::Ffmpeg.merge(
          input: output[Constants::ExecutionProcessHandles::COMPRESS_VIDEO]["path"],
          audios: output[Constants::ExecutionProcessHandles::DOWNLOAD_AUDIOS].map { |audio| audio["path"] },
          output: output[@handle]["path"]
        )
      end

      def output
        @output ||= { **previous_execution.output, "#{@handle}" => { "path" => @dir.join('merge.mp4').to_s } }
      end
    end
  end
end