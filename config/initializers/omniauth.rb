OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
  #provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
  provider :google_oauth2, "896945049396-bvmmbm7fqg7c1ok7ouk58ivqc6rc78h1.apps.googleusercontent.com", "2Z4F5ZZz9N11x7oj3JSSF31y", {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end

#896945049396-bvmmbm7fqg7c1ok7ouk58ivqc6rc78h1.apps.googleusercontent.com
#2Z4F5ZZz9N11x7oj3JSSF31y