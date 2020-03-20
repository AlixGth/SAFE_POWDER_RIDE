class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:home, :concept]

  def home
    @itineraries = policy_scope(Itinerary)
    @colors = {"1" => "#CAFF66", "2" => "#FBFF01", "3" => "#FE9800", "4" => "#FD0200", "5" => "#CB0200"}
  end

  def concept
  end
end
