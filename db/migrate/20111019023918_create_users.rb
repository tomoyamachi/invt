class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :facebook_token
      t.string :name
      t.string :email
      t.string :image_url
      t.integer :first_event_id
      t.integer :invited_num, :default => 0
      t.primary_key :id
      t.timestamps
    end
    change_column :users, :id, :bigint
#    add_index :users, :email,                :unique => true
  end

  def self.down
    drop_table :users
  end
end
