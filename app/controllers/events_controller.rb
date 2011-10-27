# -*- coding: utf-8 -*-
class EventsController < ApplicationController
  def vote_this_event
    for i in 1..params[:schedule_size]
      if params["vote#{i}"] == "yes"
        if params["schedule_id#{i}"]
          schedule = Schedule.find(params["schedule_id#{i}"])
          schedule.atnd_info ||= "[]"
          this_atnd_info = instance_eval(schedule.atnd_info).push([@user.id,@user.name])
          schedule.atnd_num = this_atnd_info.size
          schedule.save
        end
      end
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
      @ues = UserEvent.find_all_by_event_id(@event_id)
      @schedules = Schedule.find_all_by_event_id(@event_id)
    end
  end

  def get_event_info
    for i in 1..params[:part_num].to_i
      if params["wish_date#{i}"]
        if !params[:title] || params[:title] == ""
          redirect_to :detail_path,:alert => "タイトルを入力してください"
        else
          event = Event.new
          event.title = params[:title]
          event.place = params[:place]
          event.note = params[:note]
          event.status = 0
          event.open_flag = 0
          event.category = params[:category]
          if @user
            event.host_user_id = @user.id
            event.host_user_name = @user.name
          end
          event.save
          for i in 1..params[:part_num].to_i
            if params["wish_date#{i}"]
              schedule = Schedule.new
              schedule.event_id = event.id
              schedule.proposal_time = params["wish_date#{i}"] + " " + params["start_time#{i}"]
              schedule.status = 1
              schedule.rank = params["rank#{i}"].to_i
              schedule.atnd_num = 0
              schedule.save
            end
          end
            redirect_to :action => "friends_list", :e => Cipher.to_tiny(event.id)
        end
        break
      else
        redirect_to :detail_path,:alert => "候補日を一つは選んでください"
        break
      end
    end
  end

  def friends_list
    if @user
      @event_id = Cipher.from_tiny(params[:e])
      @defined_user_infos ||= []
      @defined_user_ids ||= []
      @current_friend_page ||= 0
      @defined_user_ids = []
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
    user_event.status = 1
    user_event.save
  end

  def add_friend_list_ajax
    @defined_num = params[:defined_num]
    @friend_id = params[:id]
    @name = params[:name]
  end

  def send_message
    @event_id = Cipher.from_tiny(params[:e])
    @schedules = Schedule.find_all_by_event_id(@event_id)
    ue = UserEvent.find_all_by_event_id(@event_id)
    @atnd_infos = []
    ue.each do |u|
      @atnd_infos.push([u.user_name,"http://graph.facebook.com/" + u.user_id.to_s + "/picture"])
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

  def connect_facebook_friends(page = 0,defined_user_ids = [])
    if !@user
      redirect_to "/auth/facebook?origin=%2F#{params[:controller]}%2F#{params[:action]}?e=#{params[:e]}"
    else
      if params[:e]
        @event = Event.find(Cipher.from_tiny(params[:e]))
        if !@event.host_user_id
          @event.host_user_id = @user.id
          @event.host_user_name = @user.name
        end
        @event.save
      end
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
          defined_user_ids.each do |uid|
            checked = true if uid == f["id"].to_i
          end
          @friends << [friend_name,friend_id_s,checked]
        end
      end
    end
  end

end
