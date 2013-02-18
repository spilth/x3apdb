class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.references :sector

      t.timestamps
    end
    add_index :stations, :sector_id
  end
end
