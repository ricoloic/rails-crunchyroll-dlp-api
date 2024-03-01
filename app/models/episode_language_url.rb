class EpisodeLanguageUrl < ApplicationRecord
  belongs_to :episode
  belongs_to :language
end