module Functions
  module Orchestrations
    module Executions
      class CompressVideo < Functions::Orchestrations::Executions::Base
        def execute
          return true if output[Constants::Handles::DOWNLOAD_VIDEO]["uploaded"]

          return true if Pathname.new(output[handle]["path"]).exist?

          Controls::Ffmpeg.compress(
            input: output[Constants::Handles::DOWNLOAD_VIDEO]["path"],
            output: output[handle]["path"]
          )
        end

        def output
          @output ||= {
            **previous_execution.output,
            "#{handle}" => {
              **previous_execution.output[previous_execution.handle],
              "path" => episode_dir.join('compress.mp4').to_s
            }
          }
        end

        def handle
          Constants::Handles::COMPRESS_VIDEO
        end
      end
    end
  end
end