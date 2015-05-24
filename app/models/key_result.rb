class KeyResult < ActiveRecord::Base
  belongs_to  :objective
  belongs_to  :okr, through: :objective


  validates :description, presence: true, length: { maximum: 255,
    too_long: "You should write objectives in less than %{count} characters" }
  validates :score, numericality: true

end