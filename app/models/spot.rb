class Spot < ApplicationRecord

  belongs_to :prefecture
  has_one  :spot_detail, dependent: :destroy, class_name: SpotDetail
  has_many :parkings, dependent: :destroy
  has_many :facilities, dependent: :destroy
  has_many :spot_terms, dependent: :destroy
  has_many :spot_descriptions, dependent: :destroy
  has_many :spot_images, dependent: :destroy

  has_many :spot_genres, dependent: :destroy
  has_many :genres, through: :spot_genres

  validates :ref_id, :ref_sub_id, :name, presence: true
  

end
