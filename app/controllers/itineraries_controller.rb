
class ItinerariesController < ApplicationController
 before_action :set_itinerary, only: [:show]
 skip_before_action :authenticate_user!, only: [:index, :show]

	def index
    @itineraries = policy_scope(Itinerary)
  end

  def show
    @bera = @itinerary.mountain.beras.last
    @coordinates = @itinerary.coordinates
    update_gpx_coordinates_coloring(@coordinates, @bera)
    @array = []
    @coordinates.each do |coordinate|
      if coordinate.color
        @array << [coordinate.order, coordinate.longitude, coordinate.latitude, coordinate.color]
      else
        @array << [coordinate.order, coordinate.longitude, coordinate.latitude]
      end
    end
    @array = @array.sort_by { |coordinate| coordinate[0] }
  end

  def new
    @itinerary = Itinerary.new
    @itinerary.user = current_user
    update_gpx_coordinates_coloring(coordinates)
    authorize @itinerary
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    @mountain = Mountain.find(params[:itinerary][:mountain].to_i)
    @itinerary.user = current_user
    @itinerary.mountain = @mountain
    bera = @itinerary.mountain.beras.last

    authorize @itinerary

    if @itinerary.save
      file_data = params[:itinerary][:gpx_coordinates]
      gpx_parsing(file_data, bera)

      redirect_to itinerary_path(@itinerary)
    else
      render :new
    end
  end

private

  def gpx_parsing(file_data, bera)
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
          color = array[i-1][2].to_i > bera.altitude ? "#F71F0A" : "#F7B20A"
          array[i] = [array[i][0], array[i][1], color]
          Coordinate.create(longitude: array[i][0].to_f, latitude: array[i][1].to_f, color: color, order: i, itinerary: @itinerary)
        else
          Coordinate.create(longitude: array[i][0].to_f, latitude: array[i][1].to_f, color: nil, order: i, itinerary: @itinerary)
        end
      end
    else
      redirect_to :new
    end
  end

  def update_gpx_coordinates_coloring(coordinates, bera)
    colors = {"1" => "#CAFF66", "2" => "#FBFF01", "3" => "#FE9800", "4" => "#FD0200", "5" => "#CB0200"}
    risk1 = bera.risk1
    risk2 = 3
    bera_altitude = 1500
    coordinates.each do |coordinate|
      if bera_altitude.nil?
        coordinate.color = colors[risk1.to_s]
      else
        if coordinate.altitude > bera_altitude
          coordinate.update(color: colors[risk2.to_s])
        else
          coordinate.update(color: colors[risk1.to_s])
        end
      end
    end
  end

  def itinerary_params
    params.require(:itinerary).permit(:name, :description, :duration, :elevation, :departure, :arrival, :ascent_difficulty, :ski_difficulty, photos: [])
  end

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
    authorize @itinerary
  end

end
