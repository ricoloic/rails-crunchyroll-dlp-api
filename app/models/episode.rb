class Episode < ApplicationRecord
  belongs_to :season, optional: false
  has_one :show, through: :season

  has_many :episode_language_urls

  has_many :orchestrations

  # @return [Orchestration]
  def orchestration
    orchestrations.last
  end

  def video_episode_language_url
    episode_language_urls.find_by(is_video: true)
  end

  def audio_episode_language_urls
    episode_language_urls.where(is_video: false)
  end
end