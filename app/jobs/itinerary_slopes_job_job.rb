require 'json'
require 'net/http'
require 'open-uri'

class ItinerarySlopesJobJob < ApplicationJob
  queue_as :critical

  def perform(itinerary_id)
    @itinerary = Itinerary.find(itinerary_id)
    coordinates = @itinerary.coordinates.map { |obj| [obj.longitude, obj.latitude, obj.order] }
    p coordinates
    divs = coordinates.each_slice(50).to_a
    slopes = []
    divs.each_with_index do |container, index|
      puts "#{index} CONTAINER"
      slope = queue(container)
      slope.each do |slp|
        slopes << slp
      end
    end
    puts slopes
    coordinates.each_with_index do |coordinate, index|
      coord = Coordinate.find_by(order: index+1, itinerary: @itinerary)
      if coord
        coord.update(slope: slopes[index])
      end
    end
  end

  private

  def queue(container)
    sleep(0.5)
    response = Net::HTTP.post_form URI('https://www.arcgis.com/sharing/rest/oauth2/token'),
      "f": 'json',
      "client_id": 'xosPPt3elLCXA8tk',
      "client_secret": '903d4a22e4db48e39ccedaea8e3f7c18', #ENV['ARCGIS_CLIENT_SECRET_ID']
      "grant_type": 'client_credentials'

    token = JSON.parse(response.body)['access_token']
    features = array2hash(container)
    jobId = create_job(features, token)
    res = read_status(jobId, token)
    if res == "err"
      puts "Err, sending again.."
      return queue(container)
    end
    slope = res2array(res, container.length)
    return slope
  end

  def res2array(res, length)
    array = []
    length.times do |i|
      array << res["value"]["features"][i]["attributes"]["MeanSlope"]
    end
    return array
  end

  def res2array(res, length)
    array = []
    length.times do |i|
      array << res["value"]["features"][i]["attributes"]["MeanSlope"]
    end

    return array
  end

  def array2hash(array)
    my_hash = {
      "spatialReference" => {
        "wkid" => 4326
      },
      "fields" => [
        {
          "alias" => "OBJECTID",
          "name" => "OBJECTID",
          "type" => "esriFieldTypeOID",
          "editable" => false
        },
        {
          "alias" => "Name",
          "name" => "name",
          "length" => 255,
          "type" => "esriFieldTypeString",
          "editable" => true
        },
        {
          "alias" => "Address",
          "name" => "address",
          "length" => 255,
          "type" => "esriFieldTypeString",
          "editable" => true
        }
      ],
      "objectIdField" => "OBJECTID",
      "geometryType" => "esriGeometryPoint",
      "features" => [

      ]
    }
    array.each_with_index do |lng_lat, index|
      my_hash["features"] << {
        "geometry" => {
          "x" => lng_lat[0].to_f,
          "y" => lng_lat[1].to_f,
          "spatialReference" => {
            "wkid" => 4326
          }
        },
        "attributes" => {
          "OBJECTID" => index + 1,
          "name" => (index + 1).to_s
        }
      }
    end

    return my_hash
  end

  def get_result(jobId, tk)
    url = "http://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/SummarizeElevation/jobs/#{jobId}/results/OutputSummary?token=#{tk}&f=json"
    res_serialized = open(url).read
    res = JSON.parse(res_serialized)
    return res
  end

  def read_status(jobId, tk)
    while true
      url = "http://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/SummarizeElevation/jobs/#{jobId}"
      jobStatus = Net::HTTP.post_form URI(url),
        "f": "json",
        "token": tk
        
      res = JSON.parse(jobStatus.body)

      if res["jobStatus"] == "esriJobSucceeded"
        puts "Success!"
        return get_result(jobId, tk)
      elsif res == {"error"=>{"code"=>400, "message"=>"Invalid or missing input parameters.", "details"=>[]}}
        return "err"
      end
      puts res
      sleep(2)
    end
  end

  def create_job(feature, tk)
    url = "http://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/SummarizeElevation/submitJob"
    job = Net::HTTP.post_form URI(url),
      "f": 'json',
      "token": tk,
      "returnZ": true,
      "DEMResolution": 'FINEST',
      "ProfileIDField": "OBJECTID",
      "includeSlopeAspect": true,
      "InputFeatures": feature.to_json

    res = JSON.parse(job.body)
    return res["jobId"]
  end

end
