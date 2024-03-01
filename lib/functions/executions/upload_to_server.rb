module Functions
  module Executions
    class UploadToServer < Functions::Executions::Base
      def initialize(episode:, previous_execution:)
        super(handle: Constants::ExecutionProcessHandles::UPLOAD_TO_SERVER, episode:, previous_execution:)
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

      def exec
        return true if output[Constants::ExecutionProcessHandles::DOWNLOAD_VIDEO]["uploaded"]

        return false unless make_remote_dirs

        upload
      end

      def init_next
        @next = Functions::Executions::RemoveLocalFiles.init(episode:, previous_execution: execution_process)
      end

      def start_next
        init_next if @next.blank?
        @next.start
      end

      def make_remote_dirs
        response = HTTParty.post(
          "#{@remote_url}/make_dirs",
          body: { remote_path: output[@handle]["remote_season_path"] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        response.code == 200
      end

      def upload
        response = HTTParty.post(
          "#{@remote_url}/upload",
          body: {
            local_path: output[Constants::ExecutionProcessHandles::METADATA]["path"],
            remote_path: output[@handle]["remote_location_path"]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        response.code == 200
      end

      def remote_location_path
        @remote_location_path ||= remote_season_path.join(filename)
      end

      def remote_season_path
        @remote_season_path ||= Pathname.new(@episode.season.show.title).join(@episode.season.title)
      end

      def filename
        previous_execution.output[Constants::ExecutionProcessHandles::DOWNLOAD_VIDEO]["filename"]
      end

      def output
        @output ||= {
          **previous_execution.output,
          "#{@handle}" => {
            "remote_season_path" => remote_season_path.to_s,
            "remote_location_path" => remote_location_path.to_s
          }
        }
      end
    end
  end
end