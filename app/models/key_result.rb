class KeyResult < ActiveRecord::Base
  belongs_to  :objective

  validates :description, presence: true, length: { maximum: 255,
    too_long: "Try to keep key results shorter than %{count} characters." }
  # validates :score, numericality: true DO THAT WITHIN REVIEW STEP ONLY

end