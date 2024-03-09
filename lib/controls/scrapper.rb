module Controls
  class Scrapper < Controls::Base
    COMMAND = "/home/rico/programs/python-crunchyroll-scraper/main.py".freeze

    # @param url [String]
    # @param season [Integer]
    # @param languages [Array<String>]
    # @param file [String]
    # @param skip [Integer]
    def self.download(url:, season:, languages:, file:, skip:)
      arguments = %W[-f=#{file} -s=#{season} -S=#{skip}]
      languages.each { |language| arguments << "-l=#{language}" }
      arguments << url
      return self.execute_command(COMMAND, arguments)
    end
  end
end