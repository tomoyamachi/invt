# -*- coding: utf-8 -*-
class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.integer :event_id
      t.datetime :proposal_date
      t.integer :status
      # 1:まだ決まっていない、2:この日に決定した、3:だめだった
      t.integer :rank
      #1:この日がいい。2:あんまり。。。
      t.text :atnd_infos
      #[[atnder_id,atnder_name],..]の形式をテキストで保存
      t.integer :atnd_num
      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
