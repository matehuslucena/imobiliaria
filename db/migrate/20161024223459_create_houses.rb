class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip_code
      t.float :price
      t.string :operation
      t.text :description
      t.references :customer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
