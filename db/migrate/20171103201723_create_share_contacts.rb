class CreateShareContacts < ActiveRecord::Migration
  def change
    create_table :share_contacts do |t|
      t.string :email

      t.timestamps null: false
    end
  end
end
