class Mountain < ApplicationRecord
  has_many :beras
  has_many :itineraries
  MOUNTAINS = ["Thabor", "Pelvoux", "Queyras", "Champsaur", "Devoluy", "Embrunais-Parpaillon", "Chablais"]
  validates :name, presence: true,  inclusion: { in: MOUNTAINS }
end
