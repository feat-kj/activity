class Genre < ApplicationRecord
  has_many :spot_genres
  has_many :spots, through: :spot_genres
end
