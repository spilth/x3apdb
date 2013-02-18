class Station < ActiveRecord::Base
  belongs_to :sector
  attr_accessible :name, :sector_id

  validates :name, :presence => true
  validates :sector, :presence => true
end
