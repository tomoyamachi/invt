# -*- coding: utf-8 -*-
class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.string :category
      t.text :note
      t.text :place
      t.text :category
      t.text :result_date
      # 0:未決定、1:決定済み、3:終了
      t.integer :status
      t.datetime :dead_line
      # 0:非公開、1:公開
      t.integer :open_flag
      t.integer :host_user_id
      t.text :host_user_name
      t.timestamps
    end
    change_column :events, :host_user_id, :bigint
  end

  def self.down
    drop_table :events
  end
end
