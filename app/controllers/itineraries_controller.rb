class ItinerariesController < ApplicationController
 before_action :set_itinerary, only: [:show]

	def index
    @itineraries = Itinerary.all
  end

  def show
  	@itinerary = Itinerary.find(params[:id])
  end

  def new
    @itinerary = Itinerary.new(params[:itinerary])
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    if @itinerary.save
      redirect_to itinerary_path(@itinerary)
    else
      render :new
    end
  end

private

  def itinerary_params
    params.require(:itinerary).permit(:name, :description, :duration, :elevation, :departure, :arrival, :ascent_difficulty, :ski_difficulty, :mountain_range_id)
  end

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
  end

end
