module Controls
  class Ffmpeg < Controls::Base
    COMMAND = "ffmpeg".freeze

    # Compress the video input using codec "h264_nvenc" to the output
    #
    # @param input [String]
    # @param output [String]
    def self.compress(input:, output:)
      arguments = ["-y", "-i", input, "-vcodec", "h264_nvenc", output]
      return self.execute_command(COMMAND, arguments)
    end

    # Merge (track) from the audios and subtitles to the input video resulting to output
    #
    # @param input [String]
    # @param audios [Array<String>]
    # @param subtitles [Array<String>]
    # @param output [String]
    def self.merge(input:, audios:, subtitles: [], output:)
      arguments = ["-y", "-i", input]

      audios.each { |audio| arguments.concat(["-i", audio]) }
      subtitles.each { |subtitle| arguments.concat(["-i", subtitle]) }

      arguments.concat(%w[-c:v copy -map 0])

      audios.each.with_index { |_, i| arguments.concat(%W[-map #{i + 1}:a]) }
      subtitles.each.with_index do |sub, i|
        lang = self.subtitle_lang_to_iso639_2(sub.match(/\.([a-z]{2})-.*\.ass$/)[1])
        arguments.concat(%W[-map #{audios.length + i + 1}:s -c:s mov_text]) unless lang.blank?
      end

      arguments << output

      return self.execute_command(COMMAND, arguments)
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
    def self.metadata(input:, original_language:, other_languages:, subtitles: [], output:)
      arguments = ["-y", "-i", input, "-map", "0", "-c", "copy", "-metadata:s:a:0", "title=#{original_language["name"]}", "-metadata:s:a:0", "language=#{original_language["code"]}"]
      other_languages.each.with_index { |other, i| arguments.concat(["-metadata:s:a:#{i + 1}", "title=#{other["name"]}", "-metadata:s:a:#{i + 1}", "language=#{other["code"]}"]) }
      index = 0
      subtitles.each do |sub|
        lang = self.subtitle_lang_to_iso639_2(sub.match(/\.([a-z]{2})-.*\.ass$/)[1])
        unless lang.blank?
          arguments.concat(%W[-metadata:s:s:#{index} title=#{sub.match(/\.([a-z]{2}-.*)\.ass$/)[1]} -metadata:s:s:#{index} language=#{lang}])
          index += 1
        end
      end
      arguments << output
      return self.execute_command(COMMAND, arguments)
    end

    def self.subtitle_lang_to_iso639_2(lang)
      lang_map = {
        "en" => "eng",
        "es" => "spa",
        "fr" => "fra",
        "it" => "ita"
      }

      lang_map[lang.downcase]
    end
  end
end