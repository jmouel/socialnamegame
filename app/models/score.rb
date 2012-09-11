class Score < ActiveRecord::Base

  belongs_to :user

  attr_accessible :value, :created_at, :user_id
end
