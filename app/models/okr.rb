class Okr < ActiveRecord::Base
  has_many :objectives, dependent: :destroy
  has_many :key_results, through: :objectives

  validates_associated :objectives
  validates :admin_name, :admin_email, :owner, :period, presence: true
  # validates unique email - owner - period trio
end
