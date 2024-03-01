module Functions
  module Executions
    class Metadata < Functions::Executions::Base
      def initialize(episode:, previous_execution:)
        super(handle: Constants::ExecutionProcessHandles::METADATA, episode:, previous_execution:)
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
        @next = Functions::Executions::UploadToServer.init(episode:, previous_execution: execution_process)
      end

      def start_next
        init_next if @next.blank?
        @next.start
      end

      def exec
        return true if output[Constants::ExecutionProcessHandles::DOWNLOAD_VIDEO]["uploaded"]

        return true if Pathname.new(output[@handle]["path"]).exist?

        original_language = {
          "code" => @episode.video_episode_language_url.language.code,
          "name" => @episode.video_episode_language_url.language.name
        }

        Controls::Ffmpeg.metadata(
          input: output[Constants::ExecutionProcessHandles::MERGE_AUDIO_STREAMS]["path"],
          original_language:,
          other_languages: output[Constants::ExecutionProcessHandles::DOWNLOAD_AUDIOS],
          output: output[@handle]["path"]
        )
      end

      def output
        @output ||= { **previous_execution.output, "#{@handle}" => { "path" => @dir.join('metadata.mp4').to_s } }
      end
    end
  end
end