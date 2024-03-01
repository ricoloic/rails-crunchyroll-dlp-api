module Controls
  class Ffmpeg < Controls::Base
    COMMAND = "ffmpeg".freeze

    # Compress the video input using codec "h264_nvenc" to the output
    #
    # @param input [String]
    # @param output [String]
    def self.compress(input:, output:)
      arguments = ["-y", "-i", input, "-vcodec", "h264_nvenc", output]
      self.exec(COMMAND, arguments)
    end

    # Merge (track) from the audios to the input video resulting to output
    #
    # @param input [String]
    # @param audios [Array<String>]
    # @param output [String]
    def self.merge(input:, audios:, output:)
      arguments = ["-y", "-i", input]
      audios.each { |audio| arguments.concat(["-i", audio]) }
      arguments.concat(%w[-c:v copy -map 0])
      audios.each.with_index { |_, i| arguments.concat(%W[-map #{i + 1}:a]) }
      arguments << output
      self.exec(COMMAND, arguments)
    end

    # Set the track metadata of the input resulting to output
    #
    # @param input [String]
    # @param original_language [Hash]
    # @option original_language [String] :code
    # @option original_language [String] :name
    # @param other_languages [Array<Hash>]
    # @option other_languages [String] :code
    # @option other_languages [String] :name
    # @param output [String]
    def self.metadata(input:, original_language:, other_languages:, output:)
      arguments = ["-y", "-i", input, "-map", "0", "-c", "copy", "-metadata:s:a:0", "title=#{original_language["name"]}", "-metadata:s:a:0", "language=#{original_language["code"]}"]
      other_languages.each.with_index { |other, i| arguments.concat(["-metadata:s:a:#{i + 1}", "title=#{other["name"]}", "-metadata:s:a:#{i + 1}", "language=#{other["code"]}"]) }
      arguments << output
      self.exec(COMMAND, arguments)
    end
  end
end