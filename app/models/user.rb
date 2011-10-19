class User < ActiveRecord::Base
# t.integer :id, :null => false
# t.string :facebook_token
# t.string :name
# t.string :email
# t.string :image_url
# t.integer :first_event_id

  def self.find_or_create_from_auth_hash(authhash)
    user = User.find_by_id(authhash["uid"].to_i)
    unless user
      user = User.new
      user.id = authhash["uid"].to_i
      user_info = authhash["user_info"]
      user.name = user_info["name"]
      user.email = user_info["email"]
      user.image_url = user_info["image"]
      user.save
    end
    return user
  end
end
