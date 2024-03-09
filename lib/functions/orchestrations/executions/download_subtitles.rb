module Functions
  module Orchestrations
    module Executions
      class DownloadSubtitles < Functions::Orchestrations::Executions::Base
        def execute
          return true if output[Constants::Handles::DOWNLOAD_VIDEO]["uploaded"]

          success = Controls::YtDlp.subtitle(
            url: output[handle]["url"],
            email: @email,
            password: @password,
            cookies: cookie_filepath.to_s,
            output: sub_dir.join("%(title)s.%(ext)s").to_s,
          )
          !!success
        end

        def output
          @output ||= {
            **previous_execution.output,
            "#{handle}" => {
              "url" => episode.video_episode_language_url.url
            }
          }
        end

        def handle
          Constants::Handles::DOWNLOAD_SUBTITLES
        end
      end
    end
  end
end