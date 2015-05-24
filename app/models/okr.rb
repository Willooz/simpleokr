class Okr < ActiveRecord::Base
  has_many :objectives, dependent: :destroy
  has_many :key_results, through: :objectives
end
