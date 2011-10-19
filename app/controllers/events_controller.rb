class EventsController < ApplicationController
  def get_friends_info
    @user = session["user"]
    require 'cgi'
    url = "https://graph.facebook.com/#{@user.id.to_s}/friends?access_token=#{CGI.escape(session["f_token"])}"
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.path + "?" + uri.query)
    response = http.request(request)
    p data = response.body
    p pdata = JSON.parse(data)
    if pdata.key?("error") && pdata["error"]["message"] =~ /Session has expired/
      redirect_to "/auth/facebook"
    else
      redirect_to :action => "friends_list"
    end
  end

  def friends_list
    @user = session["user"]
    require 'cgi'
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
      parse_data["data"][0..10].each do |f|
        friend_name = f["name"]
        friend_img = "http://graph.facebook.com/" + f["id"].to_s + "/picture"
        @friends << [friend_name,friend_img]
      end
    end
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
  def calendar_ajax
    params[:year] ||= Date.today.year
    params[:month] ||= Date.today.month
    @t = Date.new(params[:year].to_i,params[:month].to_i,1)
    @this_month_flag = true if @t.month == Date.today.month && @t.year == Date.today.year
    @start_youbi = Date.new(@t.year, @t.month, 1).cwday % 7
    @max_day = (Date.new(@t.next_month.year, @t.next_month.month, 1) - 1).day
  end
  # GET /events
  # GET /events.xml
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end
end
