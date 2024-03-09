module Functions
  module Orchestrations
    module Executions
      class Metadata < Functions::Orchestrations::Executions::Base
        def execute
          return true if output[Constants::Handles::DOWNLOAD_VIDEO]["uploaded"]

          return true if Pathname.new(output[handle]["path"]).exist?

          original_language = {
            "code" => episode.video_episode_language_url.language.code,
            "name" => episode.video_episode_language_url.language.name
          }
          files = Dir[sub_dir.join("**/*.ass").to_s]


          Controls::Ffmpeg.metadata(
            input: output[Constants::Handles::MERGE_AUDIO_STREAMS]["path"],
            original_language:,
            other_languages: output[Constants::Handles::DOWNLOAD_AUDIOS],
            subtitles: files,
            output: output[handle]["path"]
          )
        end

        def output
          @output ||= {
            **previous_execution.output,
            "#{handle}" => {
              **previous_execution.output[previous_execution.handle],
              "path" => episode_dir.join('metadata.mp4').to_s
            }
          }
        end

        def handle
          Constants::Handles::METADATA
        end
      end
    end
  end
end