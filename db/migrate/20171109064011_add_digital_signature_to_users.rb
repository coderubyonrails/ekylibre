class AddDigitalSignatureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :digital_signature, :text
  end
end
