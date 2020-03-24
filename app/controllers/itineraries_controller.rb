
class ItinerariesController < ApplicationController
 before_action :set_itinerary, only: [:show, :download_pdf]
 skip_before_action :authenticate_user!, only: [:index, :show, :download_pdf]

	def index
    @colors = {"1" => "#CAFF66", "2" => "#FBFF01", "3" => "#FE9800", "4" => "#FD0200", "5" => "#CB0200"}
    @params_present = params[:query].present?
    @results_count = policy_scope(Itinerary).search_by_name_and_mountain(params[:query]).count
    if @params_present && @results_count > 0
      @itineraries = policy_scope(Itinerary).search_by_name_and_mountain(params[:query])
    else
      @itineraries = policy_scope(Itinerary)
    end

  end

  def show
    colors = {"1" => "#CAFF66", "2" => "#FBFF01", "3" => "#FE9800", "4" => "#FD0200", "5" => "#CB0200"}
    @bera = @itinerary.mountain.beras.last
    @bera_color = colors[@bera.risk_max.to_s]
    coordinates = @itinerary.coordinates
    update_gpx_coordinates_coloring(coordinates, @bera)
    @coordinates = @itinerary.coordinates
    @waypoints = generate_waypoints(@coordinates)
    favorite = Favorite.where(user: current_user).where(itinerary: @itinerary)
    @favorite = false
    @favorite = true if favorite.exists?
  end

  def download_pdf
    require 'grabzit'
    #warning: API key to be placed in ENV
    grabzItClient = GrabzIt::Client.new("MTRhYTY1MDk4MzMwNDZiY2JmOWRlZGQ3ZmRmY2MyMTc=", "Pz89Pz8/BT9jPzNDW0c/XSA/PwY/P1o/Py0/Wkg/Pz8=")
    grabzItClient.url_to_pdf("https://au-coin-du-ski.herokuapp.com/products/29")
    grabzItClient.save_to("safe_powder_ride_#{@itinerary.name}.pdf")
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

def generate_waypoints(coordinates)
  array = []
  coordinates.each do |coordinate|
    array << [coordinate.order, coordinate.longitude, coordinate.latitude, coordinate.color]
  end
  array = array.sort_by { |coordinate| coordinate[0] }
end

  def gpx_parsing(file_data, bera)
    if file_data.respond_to?(:path)
      doc = Nokogiri::XML(open(file_data.path))
      trackpoints = doc.xpath('//xmlns:trkpt')
      coordinates = []
      doc.search('trkpt').each_with_index do |trkpt, index|
        ele = trkpt.search('ele').text
        coordinates <<  [trkpt.attribute("lon").value, trkpt.attribute("lat").value, ele ]
      end
      reduce_value = (coordinates.size.to_f / 300).round
      coordinates = coordinates.select.with_index do |coordinate, index|
        index % reduce_value == 0
      end

      create_coordinates(coordinates)

    else
      redirect_to :new
    end
  end

  def create_coordinates(coordinates)
    for i in (0...coordinates.size)
      coord = Coordinate.create(longitude: coordinates[i][0].to_f, latitude: coordinates[i][1].to_f, altitude: coordinates[i][2].to_f, order: i, itinerary: @itinerary)
    end
  end

  def update_gpx_coordinates_coloring(coordinates, bera)
    colors = {"1" => "#CAFF66", "2" => "#FBFF01", "3" => "#FE9800", "4" => "#FD0200", "5" => "#CB0200"}
    risk1 = bera.evolrisk1 ? [bera.risk1, bera.evolrisk1].max : bera.risk1
    risk2 = bera.evolrisk2 ? [bera.risk2, bera.evolrisk2].max : bera.risk2
    bera_altitude = bera.altitude
    coordinates.each do |coordinate|
      if bera_altitude.nil?
        coordinate.update!(color: colors[risk1.to_s])
      else
        if coordinate.altitude > bera_altitude
          coordinate.update!(color: colors[risk2.to_s])
        else
          coordinate.update!(color: colors[risk1.to_s])
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
