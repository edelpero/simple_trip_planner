class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.references :user, index: true
      t.string :destination
      t.date :start_date
      t.date :end_date
      t.text :comment

      t.timestamps
    end
  end
end
