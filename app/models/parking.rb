class Parking < ApplicationRecord
  belongs_to :spot
  belongs_to :prefecture
end
