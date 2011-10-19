require 'omniauth/oauth'

app_id = "170649486355496"
app_secret = "52e3faee32d43223872f1c98b26a72e6"
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook , app_id , app_secret , { :scope => 'email, status_update, publish_stream' }
end
