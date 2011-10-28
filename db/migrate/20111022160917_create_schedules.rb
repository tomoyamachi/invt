# -*- coding: utf-8 -*-
class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.integer :event_id
      t.string :proposal_time
      t.integer :status,:default => 0
      # 1:まだ決まっていない、2:この日に決定した、3:だめだった
      t.integer :rank, :default => 0
      #1:この日がいい。2:あんまり。。。
      t.text :atnd_infos
      #[[atnder_id,atnder_name],..]の形式をテキストで保存
      t.integer :atnd_num, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
