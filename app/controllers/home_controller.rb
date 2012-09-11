class HomeController < ApplicationController
  def index
  end

  helper_method :people_count, :provider

  private

  def people_count
    @people_count = Person.where(user_id: current_user.id).count
  end

  def provider
    @provider = current_user.authentications.first.provider.capitalize
  end
end
