class ItinerariesController < ApplicationController
 before_action :set_itinerary, only: [:show]
 skip_before_action :authenticate_user!, only: [:index, :show]

	def index
    @itineraries = Itinerary.all
  end

  def show
  	@itinerary = Itinerary.find(params[:id])
  end

  def new
    @itinerary = Itinerary.new
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    @mountain = Mountain.find(params[:itinerary][:mountain].to_i)
    @itinerary.mountain = @mountain
    @itinerary.user = current_user
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
  end

end
