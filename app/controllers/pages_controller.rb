class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: :home

  def home
    @itineraries = policy_scope(Itinerary)
  end

  def concept
  end
end
