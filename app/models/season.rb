class Season < ApplicationRecord
  belongs_to :show, optional: false
  has_many :episodes
end