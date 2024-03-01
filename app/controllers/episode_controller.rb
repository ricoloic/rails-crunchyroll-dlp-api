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

      episode
    end

    Thread.new { episode_list.each { |episode| Functions::Executions::DownloadVideo.start(episode:) } }

    render status: 200
  end
end