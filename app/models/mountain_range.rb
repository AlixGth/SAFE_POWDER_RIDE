class MountainRange < ApplicationRecord
  belongs_to :RiskLevel
  has_many :itineraries

end
