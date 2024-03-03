module Functions
  module Orchestrations
    module Executions
      class DownloadVideo < Functions::Orchestrations::Executions::Base
        def execute
          return true if output[handle]["uploaded"]

          Controls::YtDlp.video(
            url: episode.video_episode_language_url.url,
            email: @email,
            password: @password,
            cookies: cookie_filepath.to_s,
            output: output[handle]["path"]
          )
        end

        def is_uploaded?
          response = HTTParty.post(
            "#{@remote_url}/file_exist",
            body: { remote_path: remote_path.to_s }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          response.code == 200
        end

        def filename
          @filename ||= Controls::YtDlp.filename(
            url: episode.video_episode_language_url.url,
            email: @email,
            password: @password,
            cookies: cookie_filepath.to_s
          )
        end

        def remote_path
          Pathname.new(episode.season.show.title)
                  .join(episode.season.title)
                  .join(filename)
        end

        def output
          @output ||= {
            "#{handle}" => {
              "path" => episode_dir.join('original.mp4').to_s,
              "filename" => filename,
              "uploaded" => is_uploaded?,
              "remote_path" => remote_path.to_s
            }
          }
        end

        def handle
          Constants::Handles::DOWNLOAD_VIDEO
        end
      end
    end
  end
end