class FetchEpisodeMetadataJob < ApplicationJob
  queue_as :default

  def perform(episode:)
    Functions::Downloads::EpisodeMetadata.process(episode:)
  end
end
