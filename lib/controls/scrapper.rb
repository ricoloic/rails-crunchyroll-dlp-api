module Controls
  class Scrapper < Controls::Base
    COMMAND = "/home/rico/programs/python-crunchyroll-scraper/main.py".freeze

    # @param url [String]
    # @param season [Integer]
    # @param languages [Array<String>]
    # @param file [String]
    def self.download(url:, season:, languages:, file:)
      arguments = %W[-f=#{file} -s=#{season}]
      languages.each { |language| arguments << "-l=#{language}" }
      arguments << url
      return self.execute_command(COMMAND, arguments)
    end
  end
end