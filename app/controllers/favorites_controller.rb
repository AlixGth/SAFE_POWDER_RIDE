class FavoritesController < ApplicationController

  def index
    @favorites = policy_scope(Favorite)
    @colors = {"1" => "#CAFF66", "2" => "#FBFF01", "3" => "#FE9800", "4" => "#FD0200", "5" => "#CB0200"}
  end

  def create
    @favorite = Favorite.new
    authorize @favorite
    @favorite.user = current_user
    @favorite.itinerary = Itinerary.find(params[:itinerary_id])
    @favorite.save
    redirect_to itinerary_path(@favorite.itinerary)
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    authorize(@favorite)
    @favorite.destroy
    redirect_to(favorites_path)
  end
end
