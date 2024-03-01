module Functions
  module Executions
    class DownloadVideo < Functions::Executions::Base
      def initialize(episode:)
        super(handle: Constants::ExecutionProcessHandles::DOWNLOAD_VIDEO, episode:)
      end

      def self.start(episode:)
        new(episode:).start
      end

      def self.init(episode:)
        new(episode:).init
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
        @next = Functions::Executions::CompressVideo.init(episode:, previous_execution: execution_process)
      end

      def start_next
        init_next if @next.blank?
        @next.start
      end

      def exec
        return true if output[@handle]["uploaded"]

        Controls::YtDlp.video(
          url: @episode.video_episode_language_url.url,
          email: @email,
          password: @password,
          cookies: @cookies.to_s,
          output: output[@handle]["path"]
        )
      end

      def is_uploaded?
        response = HTTParty.post(
          "#{@remote_url}/file_exist",
          body: { remote_path: remote_location_path.to_s }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        response.code == 200
      end

      def filename
        @filename ||= Controls::YtDlp.filename(
          url: @episode.video_episode_language_url.url,
          email: @email,
          password: @password,
          cookies: @cookies.to_s
        )
      end

      def remote_location_path
        @remote_location_path ||= Pathname.new(@episode.season.show.title).join(@episode.season.title).join(filename)
      end

      def output
        @output ||= {
          "#{@handle}" => {
            "path" => @dir.join('original.mp4').to_s,
            "filename" => filename,
            "uploaded" => is_uploaded?
          }
        }
      end
    end
  end
end