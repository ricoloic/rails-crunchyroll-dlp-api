module Functions
  module Downloads
    class EpisodeMetadata
      # @param episode [Episode]
      def initialize(episode:)
        @episode = episode
      end

      # @param episode [Episode]
      def self.process(episode:)
        new(episode:).process
      end

      def process
        description = @episode.description
        thumbnail_url = @episode.thumbnail_url

        description = get_description(@episode) if description.blank?
        thumbnail_url = get_thumbnail(@episode) if thumbnail_url.blank?

        @episode.update(description:, thumbnail_url:)

        self
      end

      def get_thumbnail(episode)
        email = ENV["CRUNCHYROLL_EMAIL"]
        password = ENV["CRUNCHYROLL_PASSWORD"]
        cookies = Pathname.new("/").join("home").join("rico").join("www.crunchyroll.com_cookies.txt").to_s
        Controls::YtDlp.thumbnail(
          url: episode.video_episode_language_url.url,
          email: email,
          password: password,
          cookies: cookies
        )
      end

      def get_description(episode)
        email = ENV["CRUNCHYROLL_EMAIL"]
        password = ENV["CRUNCHYROLL_PASSWORD"]
        cookies = Pathname.new("/").join("home").join("rico").join("www.crunchyroll.com_cookies.txt").to_s
        Controls::YtDlp.description(
          url: episode.video_episode_language_url.url,
          email: email,
          password: password,
          cookies: cookies
        )
      end
    end
  end
end