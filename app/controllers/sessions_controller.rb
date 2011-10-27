class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session["user"] = @user
    session["f_token"] = auth_hash["credentials"]["token"]
    redirect_to request.env['omniauth.origin'] || '/'
  end
  def destroy
    reset_session
    redirect_to "/"
  end
  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
