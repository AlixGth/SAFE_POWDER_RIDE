class Bera < ApplicationRecord
  RISKS = [1, 2, 3, 4, 5]
  belongs_to :mountain

  validates :mountain, uniqueness: { scope: :bra_date }
end
