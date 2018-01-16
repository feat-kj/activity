class Spot < ApplicationRecord

  belongs_to :prefecture
  has_one  :spot_detail, :dependent => :destroy
  has_many :parkings
  has_many :spot_terms, :dependent => :destroy
  has_many :spot_genres
  has_many :genres, through: :spot_genres

end
