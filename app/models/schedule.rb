# -*- coding: utf-8 -*-
class Schedule < ActiveRecord::Base
# t.integer :event_id
# t.string :proposal_time
# t.integer :status
# # 0:まだ決まっていない、1:この日に決定した、2:だめだった
# t.integer :rank
# #1:この日がいい。2:あんまり。。。
# t.text :atnd_infos
# #[[atnder_id,atnder_name],..]の形式をテキストで保存
# t.integer :atnd_num
# t.timestamps
  def self.new_schedule(date)
    s = Schedule.new
    s.proposal_time = date
    s.atnd_infos ||= "[]"
    s.atnd_num = 0
    s.status = 0
    return s
  end

end
