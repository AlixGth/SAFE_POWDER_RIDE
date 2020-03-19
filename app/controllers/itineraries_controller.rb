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
      file_data = params[:itinerary][:gpx_coordinates]
      if file_data.respond_to?(:path)
        doc = Nokogiri::XML(open(file_data.path))
        trackpoints = doc.xpath('//xmlns:trkpt')
        array = []
        doc.search('trkpt').each_with_index do |trkpt, index|
          ele = trkpt.search('ele').text
          array <<  [trkpt.attribute("lon").value, trkpt.attribute("lat").value, ele ]
        end
        reduce_value = (array.size.to_f / 300).round
        array = array.select.with_index do |coordinate, index|
          index % reduce_value == 0
        end
        for i in (0...array.size)
          if i != 0 && i % 4 == 0
            color = array[i-1][2].to_i > 1500 ? "#F71F0A" : "#F7B20A"
            array[i] = [array[i][0], array[i][1], color]
            Coordinate.create(longitude: array[i][0].to_f, latitude: array[i][1].to_f, color: color, order: i, itinerary: @itinerary)
          else
            Coordinate.create(longitude: array[i][0].to_f, latitude: array[i][1].to_f, color: nil, order: i, itinerary: @itinerary)
          end
        end
      else
        redirect_to :new
      end
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
