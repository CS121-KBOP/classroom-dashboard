OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    config = Rails.application.config.x.settings["oauth2"]
    provider :google_oauth2, '433563434451-e8n8onq2e57imkcs0ql9jalabtv8oapq.apps.googleusercontent.com', 'fDOSEqcn7151FFr7G60r7hc2', skip_jwt: true
end
