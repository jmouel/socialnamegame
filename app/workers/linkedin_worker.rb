class LinkedinWorker
  include ApplicationHelper, Sidekiq::Worker

  sidekiq_options :queue => :crawler, :retry => false

  def perform(options)
    user_id = options['user'].to_i
    a = Authentication.find_by_user_id_and_provider(user_id, 'linkedin')

    li = LinkedIn::Client.new(Rails.configuration.linkedin['key'], Rails.configuration.linkedin['secret'])
    li.authorize_from_access(a.token, a.refresh_token)

    connections = li.connections(fields: ['formatted-name', 'picture-url'])

    ActiveRecord::Base.transaction do
      connections.all.each do |connection|
        if connection['picture-url'] and connection['formatted-name']
          Person.create(user_id: user_id,
                        name: connection['formatted-name'],
                        provider: LINKEDIN,
                        photo_url: connection['picture-url'])
        end
      end
    end
  end
end
