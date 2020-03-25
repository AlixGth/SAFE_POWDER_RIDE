require 'json'
require 'net/http'
require 'open-uri'

class ItinerariesController < ApplicationController
 before_action :set_itinerary, only: [:show, :download_pdf]
 skip_before_action :authenticate_user!, only: [:index, :show, :download_pdf]

	def index
    @colors = {"1" => "#CAF567", "2" => "#FDF733", "3" => "#F39831", "4" => "#ED462F", "5" => "#ED462F"}
    @params_present = params[:query].present?
    @results_count = policy_scope(Itinerary).search_by_name_and_mountain(params[:query]).count
    if @params_present && @results_count > 0
      @itineraries = policy_scope(Itinerary).search_by_name_and_mountain(params[:query])
    else
      @itineraries = policy_scope(Itinerary)
    end

  end

  def show
    colors = {"1" => "#CAF567", "2" => "#FDF733", "3" => "#F39831", "4" => "#ED462F", "5" => "#ED462F"}
    @bera = @itinerary.mountain.beras.last
    @bera_color = colors[@bera.risk_max.to_s]
    coordinates = @itinerary.coordinates
    update_gpx_coordinates_coloring(coordinates, @bera)
    @coordinates = @itinerary.coordinates
    @waypoints = generate_waypoints(@coordinates)

    ascent_difficulties = {"R" => "1", "F" => "2", "PD" => "3", "AD" => "4", "D" => "5"}
    @ascent_grade = ascent_difficulties[@itinerary.ascent_difficulty]
    terrain_difficulties = {"E1" => "1", "E2" => "2", "E3" => "3", "E4" => "4"}
    @terrain_grade = terrain_difficulties[@itinerary.terrain_difficulty]

    favorite = Favorite.where(user: current_user).where(itinerary: @itinerary)
    @favorite = false
    @favorite = true if favorite.exists?
    @evolrisk = @bera.evolrisk1? || @bera.evolrisk2?
    if @bera.altitude
      @alt_lng = altitude_change(@coordinates, @bera)[0]
      @alt_lat = altitude_change(@coordinates, @bera)[1]
    end
    @naked_navbar = true
    starting_point = @coordinates.find_by(order: 0)
    end_point_id = @coordinates.count - 1
    end_point = @coordinates.find_by(order: end_point_id)
    @starting_point_alt = starting_point.altitude
    @end_point_alt = end_point.altitude
  end

  def download_pdf
    require 'grabzit'
    #warning: API key to be placed in ENV
    grabzItClient = GrabzIt::Client.new("MTRhYTY1MDk4MzMwNDZiY2JmOWRlZGQ3ZmRmY2MyMTc=", "Pz89Pz8/BT9jPzNDW0c/XSA/PwY/P1o/Py0/Wkg/Pz8=")
    grabzItClient.url_to_pdf("https://au-coin-du-ski.herokuapp.com/products/29")
    grabzItClient.save_to("../safe_powder_ride_#{@itinerary.name}.pdf")

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
      ItinerarySlopesJobJob.perform_later(@itinerary.id)
      redirect_to itinerary_path(@itinerary)
    else
      render :new
    end

    coordinates = @itinerary.coordinates
        #calculation of all data from GPX
    starting_point = coordinates.find_by(order: 0)
    end_point_id = coordinates.count - 1
    end_point = coordinates.find_by(order: end_point_id)
    starting_point_alt = starting_point.altitude
    end_point_alt = end_point.altitude
    start_address = Geocoder.search([starting_point.latitude, starting_point.longitude]).first
    if start_address.nil?
      start_address_display= 'NA'
    else
      start_village = start_address.data["address"]["village"] || start_address.data["address"]["county"]
      start_address_display = "#{start_village} (#{start_address.data["address"]["postcode"]})"
    end

    end_address = Geocoder.search([end_point.latitude, end_point.longitude]).first
    if end_address.nil?
      end_address_display = 'NA'
    else
      end_village = end_address.data["address"]["village"] || end_address.data["address"]["county"]
      end_address_display = "#{end_village} (#{end_address.data["address"]["postcode"]})"
    end
    @itinerary.elevation = calculate_itinerary_elevation(coordinates)
    @itinerary.departure = "#{start_address_display}"
    @itinerary.arrival = "#{end_address_display}"
    @itinerary.length = calculate_itinerary_length(coordinates) / 1000
    @itinerary.max_elevation = coordinates.maximum('altitude')
    @itinerary.save
  end

  private

  def create_coordinates(coordinates)
    for i in (0...coordinates.size)
      coord = Coordinate.create(longitude: coordinates[i][0].to_f, latitude: coordinates[i][1].to_f, altitude: coordinates[i][2].to_f, slope: coordinates[i][3], order: i, itinerary: @itinerary)
    end
  end

  def generate_waypoints(coordinates)
    array = []
    coordinates.each do |coordinate|
      array << [coordinate.order, coordinate.longitude, coordinate.latitude, coordinate.color, coordinate.evol_color, coordinate.slope]
    end
    array = array.sort_by { |coordinate| coordinate[0] }
  end

  def altitude_change(coordinates, bera)
    altitude_coordinate = coordinates.where("altitude >= ?", bera.altitude).first
    [altitude_coordinate.longitude, altitude_coordinate.latitude]
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


  def update_gpx_coordinates_coloring(coordinates, bera)
    colors = {"0"=> "#FFFFFF", "1" => "#CAF567", "2" => "#FDF733", "3" => "#F39831", "4" => "#ED462F", "5" => "#ED462F"}
    risk1 = bera.risk1
    risk2 = bera.risk2
    evolrisk1 = bera.evolrisk1 || bera.risk1
    evolrisk2 = bera.evolrisk2 || bera.risk2
    bera_altitude = bera.altitude
    coordinates.each do |coordinate|
      if bera_altitude.nil?
        coordinate.update!(color: colors[risk1.to_s], evol_color: colors[evolrisk1.to_s])
      else
        if coordinate.altitude > bera_altitude
          coordinate.update!(color: colors[risk2.to_s], evol_color: colors[evolrisk2.to_s])
        else
          coordinate.update!(color: colors[risk1.to_s], evol_color: colors[evolrisk1.to_s])
        end
      end
    end
  end

  def itinerary_params
    params.require(:itinerary).permit(:name, :description, :duration, :ascent_difficulty, :ski_difficulty, :terrain_difficulty, photos: [])
  end

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
    authorize @itinerary
  end

  def calculate_itinerary_elevation(coordinates)
    altitude_hash = {}
    coordinates.each do |coordinate|
      altitude_hash[coordinate.order] = coordinate.altitude
    end
    elevation = 0
    for i in 0...altitude_hash.count - 1
      if altitude_hash[i + 1] > altitude_hash[i]
        elevation += altitude_hash[i + 1] - altitude_hash[i]
      end
    end
  return elevation
  end

  def calculate_itinerary_length(coordinates)
    length = 0
    coordinate_hash = {}
    coordinates.each do |coordinate|
      coordinate_hash[coordinate.order] = [coordinate.latitude, coordinate.longitude]
    end
    for i in 0...coordinate_hash.count - 1
      length += distance(coordinate_hash[i],coordinate_hash[i+1])
    end
    return length.round
  end

  def distance(loc1, loc2)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
  end

end
