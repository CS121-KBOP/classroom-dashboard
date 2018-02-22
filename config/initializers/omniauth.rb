OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '433563434451-e8n8onq2e57imkcs0ql9jalabtv8oapq.apps.googleusercontent.com', 'fDOSEqcn7151FFr7G60r7hc2'
end
