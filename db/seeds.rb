# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


Schedule.create({ :id => 1, :event_id => 1, :proposal_time => "2011/12/5 18:30", :status => 1, :rank => 2, :atnd_infos => nil, :atnd_num => 0})

Schedule.create({:id => 2,:event_id => 1,:proposal_time => "2011/12/15 夜くらい", :status => 1, :rank => 2, :atnd_infos => nil, :atnd_num => 0})

Schedule.create({:id => 3, :event_id => 1,  :proposal_time => "2011/12/17 18:30",  :status => 1,  :rank => 1,  :atnd_infos => nil, :atnd_num => 0})

Schedule.create({:id => 4, :event_id => 1,  :proposal_time => "2012/1/5 ゆうがた",  :status => 1,  :rank => 0,  :atnd_infos => nil, :atnd_num => 0})
Event.create( :id => 1,:title => "イベントのタイトルです", :note => "細かいことはココに。たとえば「集合場所は別にどこでもいいよー」とか。まあ適当に。\r\n改行はできるけど、HTMLタグは使えません。", :status => 0, :open_flag => 0, :place => "新宿駅",:host_user_id => 1383097228,:host_user_name => "Tomoya Amachi")
