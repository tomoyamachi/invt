# -*- coding: utf-8 -*-
class EventsController < ApplicationController
  def edit_friend
    if @user
      @event_id = Cipher.from_tiny(params[:e])
      @defined_user_infos ||= []
      @defined_user_ids ||= []
      @current_friend_page ||= 0
          ue = UserEvent.find_all_by_event_id(@event_id)
          @atnd_ids = []
          ue.each do |u|
            @atnd_ids.push(u.user_id)
          end
      connect_facebook_friends(@current_friend_page)
    else
      render "_login_facebook_for_get_friends"
    end
  end
  def edit_event_detail
    event_id = Cipher.from_tiny(params[:e])
    @event = Event.find(event_id)
    @title = @event.title
    @note = @event.note
    @place = @event.place
  end

  def update_detail
    event_id = Cipher.from_tiny(params[:e])
    event = Event.find(event_id)
    params_event_detail(event)
    event.save
    redirect_to :action => params[:from], :e => params[:e]
  end

  def edit_schedule
    event_id = Cipher.from_tiny(params[:e])
    @schedules = Schedule.find_all_by_event_id(event_id)
  end

  def send_decided_message
    event_id = Cipher.from_tiny(params[:e])
    @event = Event.find(event_id)
    @schedule = Schedule.where("event_id = ? AND status = ?",event_id,1).first
    @ues = UserEvent.find_all_by_event_id(event_id)

  end

  def update_schedule
    event_id = Cipher.from_tiny(params[:e])
    @event = Event.find(event_id)
    if params[:decide]
      s = Schedule.find(params["decide"].to_i)
      s.status = 1
      s.save
      @event.status = 1
      @event.result_date = s.proposal_time
      @event.save
      redirect_to :action => "send_decided_message", :e => params[:e]
    else
      for i in 1..params[:schedules_num].to_i
        if params["delete#{i}"]
          s = Schedule.find(params["delete#{i}"].to_i)
          s.destroy
        end
      end
      create_schedules
      redirect_to :action => params[:from], :e => params[:e]
   end
  end

  def vote_this_date
    for i in 1..params[:schedule_size].to_i
      if params["vote#{i}"] == "yes"
        if params["schedule_id#{i}"]
          schedule = Schedule.find(params["schedule_id#{i}"])
          atnd_infos = schedule.atnd_infos
          atnd_infos ||= "[]"
          this_atnd_infos = instance_eval(atnd_infos).push([@user.id,@user.name])
          schedule.atnd_infos = this_atnd_infos.to_s
          schedule.atnd_num = this_atnd_infos.size
          schedule.save
          @flag = true
        end
      end
    end
    if @flag
      @user.invited_num -= 1 if @user.invited_num > 0
      @event_id = Cipher.from_tiny(params[:e])
      @ue = UserEvent.where("user_id = ? AND event_id = ?",@user.id,@event_id).first
      @ue.status = 1
      @ue.save
    end
    redirect_to :action => "send_voted_message", :e => params[:e]
  end

  def send_voted_message
    if params[:e]
      @event_id = Cipher.from_tiny(params[:e])
      @event = Event.find(@event_id)
    end
  end

  def voting_ajax
    @i = params[:ident_num]
    @vote = params[:vote]
  end

  def show
    if params[:e]
      @event_id = Cipher.from_tiny(params[:e])
      @event = Event.find(@event_id)
      @host_flag = true if @user && @event.host_user?(@user.id)
      @ues = UserEvent.find_all_by_event_id(@event_id)
      if @event.status == 1
        @decided_flag = true
        @schedule = Schedule.where("event_id = ? AND status = ?",@event_id,1).first
        render "_show_decided_event"
      else
        @schedules = Schedule.find_all_by_event_id(@event_id)
      end
    end
  end

  def get_event_info
      if params["wish_date1"] || params["wish_date2"] || params["wish_date3"]
        if !params[:title] || params[:title] == ""
          redirect_to :detail_path,:alert => "タイトルを入力してください"
        else
          # save new Event
          @event = Event.new
          params_event_detail(@event)
          # ユーザがまだfacebook loginしてないときは、friends_listで上書き
          if @user
            @event.host_user_id = @user.id
            @event.host_user_name = @user.name
          end
          @event.save
          # Scheduleを保存
          create_schedules
          redirect_to :action => "friends_list", :e => Cipher.to_tiny(@event.id)
        end
      else
        redirect_to :detail_path,:alert => "候補日を一つは選んでください"
      end
  end

  def friends_list
    if @user
      event_id = Cipher.from_tiny(params[:e])
      event = Event.find(event_id)
      if !event.host_user_id
        event.host_user_id = @user.id
        event.host_user_name = @user.name
        event.save
      end
      @defined_user_infos ||= []
      @defined_user_ids ||= []
      @current_friend_page ||= 0
      connect_facebook_friends(@current_friend_page)
    else
      render "_login_facebook_for_get_friends"
    end
  end

  def get_friends_ajax
    # 次へ、前へボタンを押されたとき
    if params[:next] || params[:prev]
      @event_id = Cipher.from_tiny(params[:e])
      @defined_user_infos = instance_eval(params[:defined_user_infos])
      @defined_user_ids = instance_eval(params[:defined_user_ids])
      for i in 1..FRIENDS_PER_PAGE
        if params["id#{i}"]
          @defined_user_id  = params["id#{i}"].to_i
          @defined_user_name = params["name#{i}"]
          @defined_user_ids.push(@defined_user_id)
          @defined_user_infos.push([@defined_user_id,@defined_user_name])
        end
      end

      @current_friend_page = params[:current_page]
      @current_friend_page ||= 0
      if params[:next]
        @current_friend_page = @current_friend_page.to_i + 1
      else
        @current_friend_page = @current_friend_page.to_i - 1
      end
      connect_facebook_friends(@current_friend_page,@defined_user_ids)

    else
      @event_id = Cipher.from_tiny(params[:e])
      # 誘う友人を決めおわったとき。
      # まだparams[:defined_user_infos]に登録されてない人たち
      for i in 1..FRIENDS_PER_PAGE
        if params["id#{i}"]
          save_or_create_invite_user_and_create_user_event_table(params["id#{i}"].to_i , params["name#{i}"],@event_id)
        end
      end
      # すでにparamsの中に入っている人たち
      instance_eval(params[:defined_user_infos]).each do |id,name|
        save_or_create_invite_user_and_create_user_event_table(id.to_i,name,@event_id)
      end
      redirect_to :action => "send_message", :e => Cipher.to_tiny(@event_id)
    end
  end

  def add_friend_list_ajax
    @defined_num = params[:defined_num]
    @friend_id = params[:id]
    @name = params[:name]
  end

  def send_message
    @event_id = Cipher.from_tiny(params[:e])
    @event = Event.find(@event_id)
    @schedules = Schedule.find_all_by_event_id(@event_id)
    ue = UserEvent.find_all_by_event_id(@event_id)
    @atnd_infos = []
    ue.each do |u|
      user_image = "http://graph.facebook.com/" + u.user_id.to_s + "/picture"
      @atnd_infos.push([u.user_name,user_image])
    end
  end

  def detail;calendar_ajax;end
  def _calendar;calendar_ajax;end
  def _wish_date;calendar_ajax;end

  private
  def calendar_ajax
    params[:year] ||= Date.today.year
    params[:month] ||= Date.today.month
    @t = Date.new(params[:year].to_i,params[:month].to_i,1)
    @this_month_flag = true if @t.month == Date.today.month && @t.year == Date.today.year
    @start_youbi = Date.new(@t.year, @t.month, 1).cwday % 7
    @max_day = (Date.new(@t.next_month.year, @t.next_month.month, 1) - 1).day
  end

  def params_event_detail(event)
    event.title = params[:title]
    event.place = params[:place]
    event.note = params[:note]
    event.category = params[:category]
  end

  def connect_facebook_friends(page = 0,defined_user_ids = [])
    require 'cgi'
    require "net/http"
    url = "https://graph.facebook.com/#{@user.id.to_s}/friends?access_token=#{CGI.escape(session["f_token"])}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.path + "?" + uri.query)
    response = http.request(request)
    data = response.body
    parse_data = JSON.parse(data)
    if parse_data.key?("error") && parse_data["error"]["message"] =~ /Session has expired/
      redirect_to "/auth/facebook?origin=%2F#{params[:controller]}%2F#{params[:action]}?e=#{params[:e]}"
    else
      @friends = []
      parse_data["data"][FRIENDS_PER_PAGE * page.. FRIENDS_PER_PAGE * (page + 1)].each do |f|
        friend_name = f["name"]
        friend_id_s = f["id"].to_s
        checked = false
        checked = true if defined_user_ids.include?(f["id"].to_i)

        # フレンド情報をあとで編集するとき
        if @atnd_ids
          checked = true if @atnd_ids.include?(f["id"].to_i)
        end
        @friends << [friend_name,friend_id_s,checked]
      end
    end
  end

  def save_or_create_invite_user_and_create_user_event_table(id,name,event_id)
    invited_user = User.find_by_id(id)
    if invited_user
      invited_user.invited_num += 1
    else
      invited_user = User.new
      invited_user.id = id
      invited_user.name = name
      invited_user.invited_num = 1
      invited_user.image_url = "http://graph.facebook.com/" + id.to_s + "/picture"
    end
    invited_user.save
    # UserテーブルとEventテーブルのハブテーブル
    user_event = UserEvent.new
    user_event.user_id = invited_user.id
    user_event.user_name = invited_user.name
    user_event.event_id = event_id
    user_event.save
  end
  def create_schedules
    for i in 1..params[:part_num].to_i
      if params["wish_date#{i}"]
        schedule = Schedule.new_schedule(params["wish_date#{i}"] + " " + params["start_time#{i}"])
        schedule.event_id = @event.id
        schedule.rank = params["rank#{i}"].to_i
        schedule.save
      end
    end
  end
end
