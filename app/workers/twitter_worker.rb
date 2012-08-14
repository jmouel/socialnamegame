class TwitterWorker
  include ApplicationHelper, Sidekiq::Worker

  sidekiq_options :queue => :crawler, :retry => false

  def perform(options)
    user_id = options['user'].to_i
    a = Authentication.find_by_user_id_and_provider(user_id, 'twitter')

    tw = Twitter.configure do |config|
      config.consumer_key = Rails.configuration.twitter['key']
      config.consumer_secret = Rails.configuration.twitter['secret']
      config.oauth_token = a.token
      config.oauth_token_secret = a.refresh_token
    end

    ids = tw.friend_ids(a.info).ids.to_a + tw.follower_ids(a.info).ids.to_a

    result = []
    ids.in_groups(1 + (ids.length / 100)).each do |id_group|
      begin
        result.push tw.users(id_group)
      rescue Twitter::Error => e
        Rails.logger.debug e
      end
    end
    result.flatten!

    ActiveRecord::Base.transaction do
      result.each do |profile|
        Person.create(user_id: user_id,
                      name: profile.name,
                      provider: TWITTER,
                      photo_url: profile.profile_image_url)
      end
    end
  end
end
