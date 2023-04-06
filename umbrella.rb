require "open-uri"
require "json"

p "Where are you located?"

# user_location = gets.chomp

user_location = "Memphis"

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{ENV.fetch("GMAPS_KEY")}"

raw_response = URI.open(gmaps_url).read

parsed_response = JSON.parse(raw_response)

resuls_array = parsed_response["results"]
first_result = resuls_array[0]
geo = first_result["geometry"]

loc = geo["location"]

p latitude = loc["lat"]
p longitude = loc["lng"]

pirate_url = "https://api.pirateweather.net/forecast/REPLACE_THIS_PATH_SEGMENT_WITH_YOUR_API_TOKEN/41.8887,-87.6355"
