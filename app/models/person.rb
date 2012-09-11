class Person < ActiveRecord::Base

  belongs_to :user

  attr_accessible :external_id, :name, :photo_url, :provider, :user_id, :user
end
