class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.integer :id, :limit => 8, :null => false
      t.string :facebook_token
      t.string :name
      t.string :email
      t.string :image_url
      t.integer :first_event_id

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable
      t.timestamps
    end
    #execute "ALTER TABLE users ADD PRIMARY KEY (id);"

    add_index :users, :email,                :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
