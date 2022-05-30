require 'httparty'
require 'csv'
require_relative 'flatten'

sampleOutputURL="https://gist.githubusercontent.com/romsssss/2efc2ace305b98be85d0fe617a10ac8b/raw/a43cffb5dc2170294e9635207f18bacba2b68001/users.csv"
sampleOutput = HTTParty.get(sampleOutputURL)

#We retrieve the required columns list from the sample output. 
#We could define the columns differently
$columns = sampleOutput.split('0')[0].gsub("\n","").split(",")


# Converts a json object to a csv string
#
# @param [String, #read] the json object
# @return [String] the csv string (with line breaks)
def json_to_csv(json)
	#And turn them into a CSV string
	csv_string = CSV.generate do |csv|
	  csv << $columns
	end

	#Then we flatten each row and turn it into a csv string as well
	json.each do |r|
		#tags gets a special treatment first du to the inconsistent size
		r['tags'] = CSV.generate do |csv|
		  csv << r['tags']
		end
		r['tags'] = r['tags'].gsub("\n","")
		flattened = r.flatten_with_path()

		l =	$columns.map { |col|  flattened[col] } 
		csv_string += CSV.generate do |csv|
		  csv << l
		end
	end
	return csv_string
end


# Converts a json file to a csv string
#
# @param [String, #read] the json file http url
# @return [String] the csv string (with line breaks)
def json_file_to_csv(file_url)
	if not file_url.match(/https?:\/\//) then
		raise ArgumentError, "Please provide a valid http(s):// url"
	end
	response = HTTParty.get(file_url)
	b = response.body
	json =JSON.parse(response.body)
	return json_to_csv(json) 
end


# writes a csv string to a local file
#
# @param [String] the csv string (with line breaks)
# @param [String] the output file name
def write_csv_to_file(csv_string, outputFilename)
	File.open(outputFilename, "w") { |f| f.write csv_string}
end

#sourceURL = "https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json"
#l = json_file_to_csv(sourceURL)
#write_csv_to_file(l,"output.csv")
#
#puts l
#

# File:  tc_simple_number.rb

#require_relative "simple_number"
#require "test/unit"
# 
#class TestSimpleNumber < Test::Unit::TestCase
# 
#  def test_simple
#    assert_equal(4,4 )
##    assert_equal(4,5 )
#  end
# 
#end