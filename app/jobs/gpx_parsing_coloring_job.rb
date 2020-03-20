class GpxParsingColoringJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end

  private

  def gpx_coordinates_coloring(array)
    for i in (0...array.size)
      if i != 0 && i % 4 == 0
        color = array[i-1][2].to_i > 1500 ? "#F71F0A" : "#F7B20A"
        array[i] = [array[i][0], array[i][1], color]
        Coordinate.create(longitude: array[i][0].to_f, latitude: array[i][1].to_f, color: color, order: i, itinerary: @itinerary)
      else
        Coordinate.create(longitude: array[i][0].to_f, latitude: array[i][1].to_f, color: nil, order: i, itinerary: @itinerary)
      end
    end
  end
end
