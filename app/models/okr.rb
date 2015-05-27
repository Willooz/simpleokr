class Okr < ActiveRecord::Base
  has_many :objectives, dependent: :destroy
  has_many :key_results, through: :objectives

  accepts_nested_attributes_for :objectives, reject_if: lambda { |a| a[:description].blank? }

  validates :admin_name, :admin_email, :owner, :period, presence: true
  # validates unique email - owner - period trio
end