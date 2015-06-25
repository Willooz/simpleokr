class Okr < ActiveRecord::Base
  has_many :objectives, dependent: :destroy
  has_many :key_results, through: :objectives

  accepts_nested_attributes_for :objectives

  validates :admin_name, :admin_email, :owner, :period, presence: true
  # validates unique email - owner - period trio
  # validates_associated :objectives, :key_results
end
