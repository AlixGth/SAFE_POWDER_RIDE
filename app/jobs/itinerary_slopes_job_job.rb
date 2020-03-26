require 'json'
require 'net/http'
require 'open-uri'

class ItinerarySlopesJobJob < ApplicationJob
  queue_as :default

  def perform(itinerary_id)
    puts "PERFORMING ON ITINERARY_ID=#{itinerary_id}"
    @itinerary = Itinerary.find(itinerary_id)
    coordinates = @itinerary.coordinates.map { |obj| [obj.longitude, obj.latitude, obj.order] }
    divs = coordinates.each_slice(50).to_a
    slopes = []
    divs.each_with_index do |container, index|
      puts "CONTAINER #{index}"
      slope = queue(container, 0)
      return if !slope
      slope.each do |slp|
        slopes << slp
      end
    end
    puts slopes
    coordinates.each_with_index do |coordinate, index|
      coord = @itinerary.coordinates.find_by(order: index)
      if coord
        coord.update(slope: slopes[index])
      end
    end
  end

  private

  def queue(container, i)
    return if i > 20
    sleep(0.5)
    response = Net::HTTP.post_form URI('https://www.arcgis.com/sharing/rest/oauth2/token'),
      "f": 'json',
      "client_id": ENV['ARCGIS_CLIENT_ID'],
      "client_secret": ENV['ARCGIS_CLIENT_SECRET_ID'], 
      "grant_type": 'client_credentials'
    puts 'ENV ENV ENV'
    puts ENV['ARCGIS_CLIENT_ID']
    token = JSON.parse(response.body)['access_token']
    features = array2hash(container)
    p features
    jobId = create_job(features, token)
    res = read_status(jobId, token)
    return if !res    
    if res == "err"
      puts "Err, sending again.."
      return queue(container, i + 1)
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
    sleep(5)
    i = 0
    while i < 20
      i += 1
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
      sleep(5)
    end
    return
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
