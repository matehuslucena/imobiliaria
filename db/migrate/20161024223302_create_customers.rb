class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :phone, limit: 8
      t.string :document
      t.string :address

      t.timestamps null: false
    end
  end
end
