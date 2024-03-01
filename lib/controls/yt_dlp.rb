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
      self.exec(COMMAND, arguments)
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
      self.exec(COMMAND, arguments)
    end

    def self.filename(url:, email:, password:, cookies:)
      to_run = [COMMAND, "--username=#{email}", "--password=#{password}", "--cookies=#{cookies}", '--output="%(series)s - %(season_number)sx%(episode_number)s - %(episode)s.%(ext)s"', "--skip-download", "--get-filename", url].join(" ")
      `#{to_run}`.strip.gsub("\n", "")
    end
  end
end