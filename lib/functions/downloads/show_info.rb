require 'fileutils'
require 'json'

module Functions
  module Downloads
    class ShowInfo
      # @return [Boolean]
      attr_accessor :success
      # @return [Hash, NilClass]
      attr_accessor :data

      # @param url [String]
      # @param season [Integer]
      # @param languages [Array<String>]
      # @return [Functions::Downloads::ShowInfo]
      def initialize(url:, season:, languages:)
        @dir = Pathname.new("/").join("home").join("rico").join("personal").join("download-files").join(SecureRandom.base64(20))
        @file = @dir.join("#{Time.now.gmtime.to_s}.json")
        @url = url
        @season = season
        @languages = languages
        @success = false
        @data = nil
      end

      def process
        create_dir

        @success = Controls::Scrapper.download(url: @url, languages: @languages, season: @season, file: @file.to_s)
        @success = File.exist?(@file.to_s)
        return self unless @success

        file = File.read(@file.to_s)
        @data = JSON.parse(file)
        self
      end

      def create_dir
        FileUtils.makedirs(@dir.to_s)
      end
    end
  end
end