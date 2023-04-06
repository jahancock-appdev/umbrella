require "ascii_charts"
require "open-uri"
require "json"

puts "Where are you located?"

user_location = gets.chomp

# user_location = "Memphis"
puts "Checking the weather at #{user_location}..."

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{ENV.fetch("GMAPS_KEY")}"

raw_response = URI.open(gmaps_url).read
parsed_response = JSON.parse(raw_response)

resuls_array = parsed_response["results"]
first_result = resuls_array[0]
geo = first_result["geometry"]
loc = geo["location"]

latitude = loc["lat"]
longitude = loc["lng"]


pirate_url = "https://api.pirateweather.net/forecast/#{ENV.fetch("PIRATE_WEATHER_KEY")}/#{latitude},#{longitude}"

raw_response = URI.open(pirate_url).read

parsed_response = JSON.parse(raw_response)

puts "Your coordinates are #{parsed_response["latitude"]}, #{parsed_response["longitude"]}."

current = parsed_response["currently"]
current_temp = current["temperature"]
current_prec = current["precipProbability"]
if current_prec > 0.1
  current_cond = "Raining"
else
  current_cond = "Clear"
end
puts "It is currently #{current_temp}°F."
puts "Next hour: #{current_cond}"

hourly = parsed_response["hourly"]["data"][1..12]
rain_dummy = 0

hourly_prec = Array.new

hourly.each do |weather|
  weather_time = Time.at(weather["time"])
  weather_rain = weather["precipProbability"]
  seconds_from_now = weather_time - Time.now
  hours_from_now = (seconds_from_now / 60 / 60).round
  hourly_prec.push([hours_from_now, (weather_rain*100).round])
    if weather_rain > 0.1
      puts "In #{hours_from_now} hours, there is a #{(weather_rain*100).round}% chance of precipitation."
      rain_dummy = rain_dummy + 1
    end
end

puts AsciiCharts::Cartesian.new(hourly_prec, :bar => true, :hide_zero => true).draw


if rain_dummy > 0
  puts "You might want to take an umbrella!"
end
