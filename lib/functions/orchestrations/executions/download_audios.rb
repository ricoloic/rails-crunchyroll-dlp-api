module Functions
  module Orchestrations
    module Executions
      class DownloadAudios < Functions::Orchestrations::Executions::Base
        def execute
          return true if output[Constants::Handles::DOWNLOAD_VIDEO]["uploaded"]

          output[handle].each do |audio|
            success = Controls::YtDlp.audio(
              url: audio["url"],
              email: @email,
              password: @password,
              cookies: cookie_filepath.to_s,
              output: audio["path"]
            )
            return false unless success
          end
          true
        end

        def output
          @output ||= {
            **previous_execution.output,
            "#{handle}" => episode.audio_episode_language_urls.map do |audio|
              {
                "url" => audio.url,
                "path" => "#{audio_dir.join(audio.language.code).to_s}.m4a",
                "code" => audio.language.code,
                "name" => audio.language.name
              }
            end
          }
        end

        def handle
          Constants::Handles::DOWNLOAD_AUDIOS
        end
      end
    end
  end
end