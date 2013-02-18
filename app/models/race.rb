class Race < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :sectors
end
