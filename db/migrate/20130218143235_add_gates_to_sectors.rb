class AddGatesToSectors < ActiveRecord::Migration
  def change
    add_column :sectors, :north_sector_id, :integer
    add_column :sectors, :south_sector_id, :integer
    add_column :sectors, :east_sector_id, :integer
    add_column :sectors, :west_sector_id, :integer
  end
end
