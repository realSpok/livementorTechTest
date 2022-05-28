require 'httparty'
require 'csv'
require_relative 'flatten'

sourceURL = "https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json"
response = HTTParty.get(sourceURL)
json = JSON.parse(response.body)

def json_to_csv(json)

sampleOutputURL="https://gist.githubusercontent.com/romsssss/2efc2ace305b98be85d0fe617a10ac8b/raw/a43cffb5dc2170294e9635207f18bacba2b68001/users.csv"
#
##https://gist.githubusercontent.com/romsssss/3efc2ace305b98be85d0fe617a10ac8b/raw/a43cffb5dc2170294e9635207f18bacba2b68001/users.csv
#

sampleOutput = HTTParty.get(sampleOutputURL)

#We retrieve the columns list from the sample output
columns = sampleOutput.split('0')[0].gsub("\n","").split(",")



csv_string = CSV.generate do |csv|
  csv << columns
end
output =  csv_string
json.each do |r|
	r['tags'] = r['tags'].join(',')
	flattened = r.flatten_with_path()
	l =	columns.map { |col|  flattened[col] } 
	csv_string = CSV.generate do |csv|
	  csv << l
	end
	output += csv_string
end


return output


end

print json_to_csv(json)