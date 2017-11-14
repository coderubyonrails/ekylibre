class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :sender
      t.string :nature
      t.integer :nature_id
      t.string :receiver

      t.timestamps null: false
    end
  end
end
