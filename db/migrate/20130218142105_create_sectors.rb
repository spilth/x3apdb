class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string :name
      t.references :race

      t.timestamps
    end
    add_index :sectors, :race_id
  end
end
