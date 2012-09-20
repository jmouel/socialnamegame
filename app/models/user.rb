class User < ActiveRecord::Base
  attr_accessible :name, :photo_url

  has_many :authentications
  has_many :persons

  def self.find_from_omniauth(auth)
    auth = Authentication.find_by_provider_and_uid(auth["provider"],
                                                   auth["uid"])
    auth.user if auth
  end

  def self.create_with_omniauth(auth)
    u = User.create(name: auth["info"]["name"],
                    photo_url: auth["info"]["image"])
    a = Authentication.new(provider: auth["provider"],
                          uid: auth["uid"],
                          token: auth["credentials"]["token"],
                          refresh_token: auth["credentials"]["secret"],
                          user_id: u.id)
    case a.provider
    when 'facebook'
      a.info = auth["info"]["nickname"]
      w = FacebookWorker.new
    when 'twitter'
      a.info = auth["info"]["nickname"]
      w = TwitterWorker.new
    when 'linkedin'
      a.info = auth["info"]["nickname"]
      w = LinkedinWorker.new
    when 'salesforce'
      a.info = auth["credentials"]["instance_url"]
      w = SalesforceWorker.new
    end
    a.save

    w.perform({ 'user' => u.id }) if w
    u
  end
end
