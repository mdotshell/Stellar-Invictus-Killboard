class CreateKills < ActiveRecord::Migration[5.1]
  def change
    create_table :kills do |t|
      t.integer :identifier
      t.string :full_name
      t.string :avatar
      t.string :ship_name
      t.integer :bounty
      t.string :system_name
      t.string :site_name
      t.string :corporation
      t.string :killers
      t.string :loot

      t.timestamps
    end
  end
end
