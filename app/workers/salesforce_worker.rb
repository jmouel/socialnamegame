class SalesforceWorker
  include ApplicationHelper, Sidekiq::Worker

  sidekiq_options :queue => :crawler, :retry => false

  def perform(options)
    user_id = options['user'].to_i
    a = Authentication.find_by_user_id_and_provider(user_id, 'salesforce')

    client = Salesforce::Client.new :sobject_module => Salesforce
    client.authenticate :token => a.token, :instance_url => a.info, :refresh_token => a.refresh_token
    users = client.query 'SELECT Name, FullPhotoUrl FROM User WHERE IsActive = true'

    ActiveRecord::Base.transaction do
      users.each do |user|
        Person.create(user_id: user_id,
                      name: user.Name,
                      provider: SALESFORCE,
                      photo_url: "#{user.FullPhotoUrl}?oauth_token=#{a.token}")
      end
    end
  end
end
