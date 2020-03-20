class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:home, :concept]

  def home
    @itineraries = policy_scope(Itinerary)
  end

  def concept
  end
end
