# -*- coding: utf-8 -*-
class EventsController < ApplicationController

  def friends_list
    @defined_user_infos ||= []
    @defined_user_ids ||= []
    @current_friend_page ||= 0
    @defined_user_ids = []
    connect_facebook_friends(@current_friend_page)
  end

  def get_friends_ajax
    # 次へ、前へボタンを押されたとき
    if params[:next] || params[:prev]
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
      # 誘う友人を決めおわったとき。
      for i in 1..FRIENDS_PER_PAGE
        if params["id#{i}"]
          save_or_create_invite_user(params["id#{i}"].to_i , params["name#{i}"])
        end
      end
      instance_eval(params[:defined_user_infos]).each { |id,name| save_or_create_invite_user(id,name)}
    end
    redirect_to :action => "complete"
  end

  def save_or_create_invite_user(id,name)
    invited_user = User.find_by_id(id)
    if invited_user
      invited_user.invited_num += 1
    else
      invited_user = User.new
      invited_user.id = id
      invited_user.name = name
      invited_user.image_url ="http://graph.facebook.com/" + id.to_s + "/picture"
    end
    p invited_user
  end

  def add_friend_list_ajax
    @defined_num = params[:defined_num]
    @friend_id = params[:id]
    @name = params[:name]
  end
  def detail
    calendar_ajax
  end
  def _calendar
    calendar_ajax
  end
  def _wish_date
    calendar_ajax
  end

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
    @user = session["user"]
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
      redirect_to "/auth/facebook"
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
