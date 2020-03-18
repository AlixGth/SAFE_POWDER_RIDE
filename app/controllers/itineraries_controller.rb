class ItinerariesController < ApplicationController
 before_action :set_itinerary, only: [:show]
 skip_before_action :authenticate_user!, only: [:index, :show]

	def index
    @itineraries = policy_scope(Itinerary)
  end

  def show
  end

  def new
    @itinerary = Itinerary.new
    @itinerary.user = current_user
    authorize @itinerary
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    @mountain = Mountain.find(params[:itinerary][:mountain].to_i)
    @itinerary.user = current_user
    @itinerary.mountain = @mountain
    authorize @itinerary
    if @itinerary.save
      redirect_to itinerary_path(@itinerary)
    else
      render :new
    end
  end

private

  def itinerary_params
    params.require(:itinerary).permit(:name, :description, :duration, :elevation, :departure, :arrival, :ascent_difficulty, :ski_difficulty, photos: [])
  end

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
    authorize @itinerary
  end

end
