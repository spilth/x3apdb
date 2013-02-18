class Sector < ActiveRecord::Base
  belongs_to :race
  has_many :stations

  attr_accessible :name, :race_id, :north_sector_id, :south_sector_id, :east_sector_id, :west_sector_id

  scope :by_name, order(:name)
  
  validates :race, :presence => true

  belongs_to :north_sector, :class_name => 'Sector'
  belongs_to :south_sector, :class_name => 'Sector'
  belongs_to :east_sector, :class_name => 'Sector'
  belongs_to :west_sector, :class_name => 'Sector'

  after_save(:on => [:create, :update]) do
    north_sector.update_column(:south_sector_id, self.id) unless north_sector.nil?
    south_sector.update_column(:north_sector_id, self.id) unless south_sector.nil?
    east_sector.update_column(:west_sector_id, self.id) unless east_sector.nil?
    west_sector.update_column(:east_sector_id, self.id) unless west_sector.nil?
  end

  def to_s
    name
  end
 
end
