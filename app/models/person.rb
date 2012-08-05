class Person < ActiveRecord::Base
  attr_accessible :gender, :name, :photo_url, :provider
end
