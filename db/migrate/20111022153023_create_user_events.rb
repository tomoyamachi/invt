# -*- coding: utf-8 -*-
class CreateUserEvents < ActiveRecord::Migration
  def self.up
      t.integer :user_id, :limit => 8, :null => false
      t.integer :event_id, :null => false
      t.integer :status
    #1:未確認、2:確認済み
      t.timestamps
    end
  end

  def self.down
    drop_table :user_events
  end
end
