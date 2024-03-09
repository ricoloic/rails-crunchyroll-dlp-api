module Controls
  class YtDlp < Controls::Base
    COMMAND = "yt-dlp".freeze

    # Downloads audio from a given URL.
    #
    # @param url [String] The URL of the video or audio to download.
    # @param email [String] The email address for authentication.
    # @param password [String] The password for authentication.
    # @param cookies [String] The path to the cookies file for authentication.
    # @param output [String] The path where the audio file should be saved.
    def self.audio(url:, email:, password:, cookies:, output:)
      arguments = ["--username=#{email}", "--password=#{password}", "--cookies=#{cookies}", "--output=#{output}", "--extract-audio", "--audio-format=m4a", url]
      return self.execute_command(COMMAND, arguments)
    end

    # Downloads video from a given URL.
    #
    # @param url [String] The URL of the video or audio to download.
    # @param email [String] The email address for authentication.
    # @param password [String] The password for authentication.
    # @param cookies [String] The path to the cookies file for authentication.
    # @param output [String] The path where the audio file should be saved.
    def self.video(url:, email:, password:, cookies:, output:)
      arguments = ["--username=#{email}", "--password=#{password}", "--cookies=#{cookies}", "--output=#{output}", '--format=""best[height=1080]""', url]
      return self.execute_command(COMMAND, arguments)
    end

    # Downloads subtitle from a given URL.
    #
    # @param url [String] The URL of the video or audio to download.
    # @param email [String] The email address for authentication.
    # @param password [String] The password for authentication.
    # @param cookies [String] The path to the cookies file for authentication.
    # @param output [String] The path where the audio file should be saved.
    def self.subtitle(url:, email:, password:, cookies:, output:)
      arguments = ["--username=#{email}", "--password=#{password}", "--cookies=#{cookies}", "--output=#{output}", '--write-sub', '--all-subs', '--skip-download', url]
      return self.execute_command(COMMAND, arguments)
    end

    def self.filename(url:, email:, password:, cookies:)
      to_run = [COMMAND, "--username=#{email}", "--password=#{password}", "--cookies=#{cookies}", '--output="%(series)s - %(season_number)sx%(episode_number)s - %(episode)s.%(ext)s"', "--skip-download", "--get-filename", url].join(" ")
      `#{to_run}`.strip.gsub("\n", "")
    end

    def self.thumbnail(url:, email:, password:, cookies:)
      to_run = [COMMAND, "--username=#{email}", "--password=#{password}", "--cookies=#{cookies}", "--skip-download", "--get-thumbnail", url].join(" ")
      `#{to_run}`.strip.gsub("\n", "")
    end

    def self.description(url:, email:, password:, cookies:)
      to_run = [COMMAND, "--username=#{email}", "--password=#{password}", "--cookies=#{cookies}", "--skip-download", "--get-description", url].join(" ")
      `#{to_run}`.strip
    end
  end
end