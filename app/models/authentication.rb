class Authentication < ActiveRecord::Base

  belongs_to :user

  attr_accessible :uid, :provider, :refresh_token, :token, :info, :user_id, :data_position
end
