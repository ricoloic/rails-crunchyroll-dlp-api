require 'fileutils'

module Functions
  module Orchestrations
    module Executions
      class MergeAudioStreams < Functions::Orchestrations::Executions::Base
        def execute
          return true if output[Constants::Handles::DOWNLOAD_VIDEO]["uploaded"]

          return true if Pathname.new(output[handle]["path"]).exist?

          files = Dir[sub_dir.join("**/*.ass").to_s]
          pp files

          Controls::Ffmpeg.merge(
            input: output[Constants::Handles::COMPRESS_VIDEO]["path"],
            audios: output[Constants::Handles::DOWNLOAD_AUDIOS].map { |audio| audio["path"] },
            subtitles: files,
            output: output[handle]["path"]
          )
        end

        def output
          @output ||= {
            **previous_execution.output,
            "#{handle}" => {
              "audios" => previous_execution.output[previous_execution.handle],
              "path" => episode_dir.join('merge.mp4').to_s
            }
          }
        end

        def handle
          Constants::Handles::MERGE_AUDIO_STREAMS
        end
      end
    end
  end
end