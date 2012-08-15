
  Rails.application.config.middleware.use OmniAuth::Builder do
    c = Rails.configuration
    provider :twitter, c.twitter['key'], c.twitter['secret']
    provider :facebook, c.facebook['key'], c.facebook['secret']
    provider :linkedin, c.linkedin['key'], c.linkedin['secret'],
            { :client_options => {
                    :request_token_path => '/uas/oauth/requestToken?scope=r_network' }
            }
    provider :salesforce, c.salesforce['key'], c.salesforce['secret']
  end

