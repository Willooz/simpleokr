class KeyResult < ActiveRecord::Base
  belongs_to  :objective
  belongs_to  :okr, through: :objective
end