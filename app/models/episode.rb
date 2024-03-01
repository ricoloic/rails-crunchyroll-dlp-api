class Episode < ApplicationRecord
  belongs_to :season

  has_many :episode_language_urls
  has_many :execution_processes

  # @return [ExecutionProcess]
  def last_execution_process
    execution_processes.last
  end

  # @return [Array<ExecutionProcess>]
  def latest_execution_processes
    latest = []
    previous = last_execution_process
    while previous.present?
      latest << previous
      previous = previous.previous_execution_process
    end
    latest
  end

  def running?
    latest_execution_processes.any?(&:running?)
  end

  # @return [EpisodeLanguageUrl]
  def video_episode_language_url
    episode_language_urls.find_by(is_video: true)
  end

  def audio_episode_language_urls
    episode_language_urls.where.not(id: video_episode_language_url.id)
  end
end