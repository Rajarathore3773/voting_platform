class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :phone_number
      t.boolean :phone_verified
      t.string :phone_verification_code
      t.datetime :phone_verification_sent_at

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
  end
end
