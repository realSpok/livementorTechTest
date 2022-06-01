require 'httparty'
require 'csv'
require_relative 'flatten'

#Retrieving the needed columns from the config file
$columns = File.open("columns.config", "r").read().gsub("\n","").split(",")

# Converts a json object to a csv string
#
# @param [String, #read] the json object
# @return [String] the csv string (with line breaks)
def json_converter(json, formatter)
	#And turn them into a CSV string
	csv_string = method(formatter).call($columns)
	
	#Then we flatten each row and turn it into a csv string as well
	json.each do |r|
		#tags gets a special treatment first du to the inconsistent size
		r['tags'] = CSV.generate do |csv|
		  csv << r['tags']
		end
		r['tags'] = r['tags'].gsub("\n","")
		flattened = r.flatten_with_path()

		l =	$columns.map { |col|  flattened[col] } 
		csv_string += method(formatter).call(l)
	end
	return csv_string
end

# csv formatter, to be plugged in the json converted
#
# @param [String, #read] the list
# @return [String] the corresponding csv
def csv_formatter(l)
	csv_string = CSV.generate do |csv|
		csv << l
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
	return json_converter(json,:csv_formatter) 
end


# writes a csv string to a local file
#
# @param [String] the csv string (with line breaks)
# @param [String] the output file name
def write_csv_to_file(csv_string, outputFilename)
	File.open(outputFilename, "w") { |f| f.write csv_string}
end
