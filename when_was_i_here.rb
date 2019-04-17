require 'json'
require 'optparse'
require 'ostruct'
require 'geokit'
require 'date'

Geokit::default_units = :meters

@options = OpenStruct.new
# Defaults
@options.from = 0
@options.to   = Time.now.to_i
@options.wday = nil
@options.distance=100

OptionParser.new do |opts|
  opts.banner = 'Usage: mailqun [options]'

  opts.separator ''
  opts.separator 'Options:'

  opts.on('-f [FROM]', '--from [FROM]', Integer,
          'From timestamp') do |f|
    @options.from = f
  end

  opts.on('-t [TO]', '--to [TO]', Integer,
          'To timestamp') do |t|
    @options.to = t
  end

  opts.on('-w [WEEKDAY]', '--weekday [WEEKDAY]', Integer,
          'Weekday') do |wday|
    @options.wday = wday
  end

  opts.on('-d [DISTANCE]', '--distance [DISTANCE]', Integer,
          'Distance in meters') do |distance|
    @options.distance = distance
  end

  opts.on('--lat [LATITUDE]', Float,
          'Latitude') do |lat|
    @options.lat = lat
  end

  opts.on('--long [LONGITUDE]', Float,
          'Longitude') do |long|
    @options.long = long
  end
end.parse!

location_file=ARGV.first

data = JSON.parse(File.read(location_file))

locations = data['locations']

locations_in_range=locations.select do |location| 
  location['timestampMs'].to_i/1000>@options.from && location['timestampMs'].to_i/1000<@options.to
end

if not @options.wday.nil?
  locations_in_range=locations_in_range.select do |location| 
    Time.at((location['timestampMs'].to_i/1000)).to_date.wday == @options.wday
  end
end

coordinates_a=Geokit::LatLng.new(@options.lat, @options.long)
locations_in_radius = locations_in_range.select do |location| 
  latitude=location['latitudeE7'].to_f/10**7
  longitude=location['longitudeE7'].to_f/10**7
  coordinates_b=Geokit::LatLng.new(latitude, longitude)
  coordinates_b.distance_to(coordinates_a) < @options.distance
end

result=locations_in_radius.map do |location|
  Time.at(location['timestampMs'].to_i/1000).to_date
end.uniq.sort

puts result