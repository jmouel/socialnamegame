class HomeController < ApplicationController
  def index
  end

  def delete_account
    current_user.authentications.destroy_all
    current_user.persons.destroy_all
    redirect_to signout_path
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
