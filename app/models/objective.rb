class Objective < ActiveRecord::Base
  belongs_to  :okr
  has_many    :key_results, dependent: :destroy

  accepts_nested_attributes_for :key_results

  validates :description, presence: true, length: { maximum: 255,
    too_long: "You should write objectives in less than %{count} characters" }
end
