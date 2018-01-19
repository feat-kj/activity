class Genre < ApplicationRecord
  belongs_to :parent, class_name:Genre
  has_many :spot_genres
  has_many :spots, through: :spot_genres
  has_many :genres, foreign_key: :parent_id
end
