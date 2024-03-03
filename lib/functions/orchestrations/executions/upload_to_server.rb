module Functions
  module Orchestrations
    module Executions
      class UploadToServer < Functions::Orchestrations::Executions::Base
        def execute
          return true if output[Constants::Handles::DOWNLOAD_VIDEO]["uploaded"]

          return false unless make_remote_dirs

          response = HTTParty.post(
            "#{@remote_url}/upload",
            body: {
              local_path: output[Constants::Handles::METADATA]["path"],
              remote_path: output[handle]["remote_path"]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          response.code == 200
        end

        def make_remote_dirs
          response = HTTParty.post(
            "#{@remote_url}/make_dirs",
            body: { remote_path: output[handle]["remote_season_path"] }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          response.code == 200
        end

        def output
          @output ||= {
            **previous_execution.output,
            "#{handle}" => {
              **previous_execution.output[previous_execution.handle],
              "remote_season_path" => Pathname.new(episode.season.show.title).join(episode.season.title).to_s,
              "remote_path" => previous_execution.output[Constants::Handles::DOWNLOAD_VIDEO]["remote_path"]
            }
          }
        end

        def handle
          Constants::Handles::UPLOAD_TO_SERVER
        end
      end
    end
  end
end