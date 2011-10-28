# -*- coding: utf-8 -*-
class UserEvent < ActiveRecord::Base
# t.integer :user_id, :limit => 8, :null => false
# t.integer :event_id, :null => false
# t.integer :status
# #0:未確認、1:確認済み
# t.timestamps
  def self.find_atnd_users(event_id)
    ue_info = self.find_all_by_event_id(event_id)
    ue_info.each do |info|
      User.find info.user_id
    end
  end
  def self.find_events_from_user_id(user_id)
    ue = UserEvent.where("user_id = ?",user_id).all
    Event.find(ue.map{ |info| info.event_id})
  end
end
