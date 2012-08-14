class User < ActiveRecord::Base
  attr_accessible :name, :photo_url

  def self.find_from_omniauth(auth)
    auth = Authentication.find_by_provider_and_uid(auth["provider"], auth["uid"])
    auth.user if auth
  end

  def self.create_with_omniauth(auth)
    u = User.create(name: auth["info"]["name"], photo_url: auth["info"]["image"])
    a = Authentication.create(provider: auth["provider"],
                          uid: auth["uid"],
                          token: auth["credentials"]["token"],
                          refresh_token: auth["credentials"]["secret"],
                          info: auth["info"]["nickname"],
                          user_id: u.id)

    case a.provider
    when 'facebook'
      w = FacebookWorker.new
    when 'twitter'
      w = TwitterWorker.new
    when 'linkedin'
      w = LinkedinWorker.new
    end

    w.perform({ 'user' => u.id }) if w
    u
  end
end
