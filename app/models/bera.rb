class Bera < ApplicationRecord
  belongs_to :mountain

  validates :mountain, uniqueness: { scope: :bra_date }
end
