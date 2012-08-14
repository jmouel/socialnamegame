class Person < ActiveRecord::Base

  belongs_to :user

  attr_accessible :name, :photo_url, :provider, :user_id, :user
end
