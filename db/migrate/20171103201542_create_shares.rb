class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :sender
      t.string :nature
      t.integer :nature_id
      t.integer :receiver

      t.timestamps null: false
    end
  end
end
