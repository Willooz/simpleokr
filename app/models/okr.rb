class Okr < ActiveRecord::Base
  has_many :objectives, dependent: :destroy
  has_many :key_results, through: :objectives

  accepts_nested_attributes_for :objectives

  validates :admin_name, :admin_email, :owner, :year, :quarter, presence: true
  validates :admin_email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/,
    message: "should be a valid address. Please double check!" }
  # validates_associated :objectives, :key_results

end
