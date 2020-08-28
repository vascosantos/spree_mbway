class CreateMBWayProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_mbway_providers do |t|
      t.string :name
      t.string :key
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
