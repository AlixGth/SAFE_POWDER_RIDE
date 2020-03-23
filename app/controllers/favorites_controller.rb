class FavoritesController < ApplicationController

  def index
    @favorites = policy_scope(Favorite)
  end

  def create
    @favorite = Favorite.new
    authorize @favorite
    @favorite.user = current_user
    @favorite.itinerary = Itinerary.find(params[:itinerary_id])
    @favorite.save
  end
end
