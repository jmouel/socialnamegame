class FacebookWorker
  include ApplicationHelper, Sidekiq::Worker

  sidekiq_options :queue => :crawler, :retry => false

  def perform(options)
    user_id = options['user'].to_i
    a = Authentication.find_by_user_id_and_provider(user_id, 'facebook')
    graph = Koala::Facebook::API.new(a.token)
    friends = graph.get_connections("me", "friends")
    ids = friends[0...200].collect { |f| f['id'] }
    objects = graph.get_objects(ids)
    pictures = []

    ids.each_slice(50) do |ids_slice|
      p = graph.batch do |batch_api|
        ids_slice.each {|id| batch_api.get_picture(id, { type: 'normal' }) }
      end
      pictures << p
    end

    pictures.flatten!
    i = 0
    ActiveRecord::Base.transaction do
      objects.each do |k, v|
        Person.create(user_id: user_id,
                      name: v['name'],
                      provider: FACEBOOK,
                      photo_url: pictures[i])
        i += 1
      end
    end
  end
end
