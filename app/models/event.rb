# -*- coding: utf-8 -*-
class Event < ActiveRecord::Base
# t.string :title
# t.string :category
# t.text :note
# t.text :place
# t.text :type
# t.text :result_date
# # 0:未決定、1:決定済み、3:終了
# t.integer :status
# t.datetime :dead_line
# # 0:非公開、1:公開
# t.integer :open_flag
# t.integer :host_user_id, :limit => 8
  attr_accessor :atnd_user, :host_user
  def atnd_user?(user_id)
    UserEvent.where("event_id = ? AND user_id = ?",self.id,user_id).first
  end
  def host_user?(user_id)
    self.host_user_id == user_id
  end

end
