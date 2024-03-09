class EpisodeController < ApplicationController
  def from_url
    data = JSON.parse(request.raw_post)

    season_to_download = data["season"]
    url = data["url"]
    languages = data["languages"]
    force = !!data["force"]
    skip = data["skip"]

    return render status: 500 if url.blank? || languages.blank? || season_to_download.blank?

    episodes = Functions::Downloads::ShowInfo.new(url:, season: season_to_download, languages:, skip:).process.data

    return render status: 500 if episodes.blank?

    episode_list = process_episodes(episodes:)

    episode_list.each do |episode|
      FetchEpisodeMetadataJob.perform_later(episode:)
      orchestration = Functions::Orchestrations::Orchestrate.init(episode:, force:).orchestration
      RunOrchestrationJob.perform_later(orchestration:) unless orchestration.blank?
    end

    render status: 200
  end

  def from_json
    raw_data = request.raw_post
    data = JSON.parse(raw_data)
    episodes = data["episodes"]
    force = !!data["force"]

    episode_list = process_episodes(episodes:)

    episode_list.each do |episode|
      FetchEpisodeMetadataJob.perform_later(episode:)
      orchestration = Functions::Orchestrations::Orchestrate.init(episode:, force:).orchestration
      RunOrchestrationJob.perform_later(orchestration:) unless orchestration.blank?
    end

    render status: 200
  end

  private

  # @param episodes [Array<Hash>]
  def process_episodes(episodes:)
    episodes.map do |episode_data|
      show = Show.find_or_create_by!(
        title: episode_data['show']
      )
      season = Season.find_or_create_by!(
        position: episode_data['season'],
        title: "Season #{episode_data['season']}",
        show: show
      )
      subtitles = episode_data['subtitles'] || []
      episode = Episode.find_or_create_by!(
        title: episode_data['name'],
        position: episode_data['episode'],
        season:,
        subtitles:
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
  end
end