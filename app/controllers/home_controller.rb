class HomeController < ApplicationController
  def index
  end

  helper_method :people_count, :provider, :more_contacts?

  private

  def people_count
    @people_count = Person.where(user_id: current_user.id).count
  end

  def provider
    @provider = current_user.authentications.first.provider.capitalize
  end

  def more_contacts?
    current_user.authentications.first.data_position > 0
  end
end
