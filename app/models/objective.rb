class Objective < ActiveRecord::Base
  belongs_to  :okr
  has_many    :key_results, dependent: :destroy
end
