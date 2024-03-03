class EpisodeController < ApplicationController
  def all
    Episode.all.order(created_at: :desc)
  end

  def episodes
    raw_data = request.raw_post
    episodes = JSON.parse(raw_data)['episodes']

    episode_list = episodes.map do |episode_data|
      show = Show.find_or_create_by!(
        title: episode_data['show']
      )
      season = Season.find_or_create_by!(
        position: episode_data['season'],
        title: "Season #{episode_data['season']}",
        show: show
      )
      episode = Episode.find_or_create_by!(
        title: episode_data['name'],
        position: episode_data['episode'],
        season:
      )
      episode_data['urls'].each.with_index do |u, i|
        language = Language.find_or_create_by!(
          name: u['lang']['name'],
          code: u['lang']['code']
        )
        EpisodeLanguageUrl.find_or_create_by!(
          url: u['url'],
          is_video: i == 0,
          language:,
          episode:
        )
      end

      description = episode.description
      thumbnail_url = episode.thumbnail_url

      description = get_description(episode) if description.blank?
      thumbnail_url = get_thumbnail(episode) if thumbnail_url.blank?

      episode.update(description:, thumbnail_url:)

      episode
    end

    orchestrations = episode_list.map { |episode| Functions::Orchestrations::Orchestrate.init(episode:) }
    Thread.new { orchestrations.each { |orchestration| orchestration.process } }

    render status: 200
  end

  private

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