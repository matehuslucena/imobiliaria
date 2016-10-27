class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :user
      t.references :house

      t.timestamps null: false
    end
  end
end
