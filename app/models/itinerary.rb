class Itinerary < ApplicationRecord
  belongs_to :mountain
  belongs_to :user
  has_many :coordinates
  has_many :reviews
  has_many_attached :photos
end
