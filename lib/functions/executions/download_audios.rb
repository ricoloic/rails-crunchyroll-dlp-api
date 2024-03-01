module Functions
  module Executions
    class DownloadAudios < Functions::Executions::Base
      def initialize(episode:, previous_execution:)
        super(handle: Constants::ExecutionProcessHandles::DOWNLOAD_AUDIOS, episode:, previous_execution:)
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
        @next = Functions::Executions::MergeAudioStreams.init(episode:, previous_execution: execution_process)
      end

      def start_next
        init_next if @next.blank?
        @next.start
      end

      def exec
        return true if output[Constants::ExecutionProcessHandles::DOWNLOAD_VIDEO]["uploaded"]

        output[@handle].each do |audio|
          success = Controls::YtDlp.audio(
            url: audio["url"],
            email: @email,
            password: @password,
            cookies: @cookies.to_s,
            output: audio["path"]
          )
          return false unless success
        end
        true
      end

      def output
        @output ||= {
          **previous_execution.output,
          "#{@handle}" => @episode.audio_episode_language_urls.map do |audio|
            {
              "url" => audio.url,
              "path" => "#{@audio_dir.join(audio.language.code).to_s}.m4a",
              "code" => audio.language.code,
              "name" => audio.language.name
            }
          end
        }
      end
    end
  end
end