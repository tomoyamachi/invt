# -*- coding: utf-8 -*-
class CreateUserEvents < ActiveRecord::Migration
  def self.up
    create_table :user_events do |t|
      t.integer :user_id, :null => false
      t.text :user_name
      t.integer :event_id, :null => false
      t.integer :status
    #1:未確認、2:確認済み
      t.timestamps
    end
    change_column :user_events, :user_id, :bigint
  end

  def self.down
    drop_table :user_events
  end
end
