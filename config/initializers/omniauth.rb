Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Rails.configuration.twitter['key'], Rails.configuration.twitter['secret']
  provider :facebook, Rails.configuration.facebook['key'], Rails.configuration.facebook['secret']
  provider :linkedin, Rails.configuration.linkedin['key'], Rails.configuration.linkedin['secret'],
           { :client_options => { :request_token_path => '/uas/oauth/requestToken?scope=r_network' } }
  provider :salesforce, Rails.configuration.salesforce['key'], Rails.configuration.salesforce['secret']
end