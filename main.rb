require 'httparty'
require 'csv'

sourceURL = "https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json"
sampleOutputURL="https://gist.githubusercontent.com/romsssss/2efc2ace305b98be85d0fe617a10ac8b/raw/a43cffb5dc2170294e9635207f18bacba2b68001/users.csv"
#
##https://gist.githubusercontent.com/romsssss/2efc2ace305b98be85d0fe617a10ac8b/raw/a43cffb5dc2170294e9635207f18bacba2b68001/users.csv
#
response = HTTParty.get(sourceURL)
sampleOutput = HTTParty.get(sampleOutputURL)
json = JSON.parse(response.body)
#print json[2]

outputFormat = sampleOutput.split('0')[0]
columns = outputFormat.gsub("\n","").split(",")

module Enumerable
#source https://stackoverflow.com/questions/10712679/flatten-a-nested-json-object
  def flatten_with_path(parent_prefix = nil)
    res = {}

    self.each_with_index do |elem, i|
      if elem.is_a?(Array)
        k, v = elem
      else
        k, v = i, elem
      end

      key = parent_prefix ? "#{parent_prefix}.#{k}" : k # assign key name for result hash

      if v.is_a? Enumerable
        res.merge!(v.flatten_with_path(key)) # recursive call to flatten child elements
      else
        res[key] = v
      end
    end

    res
  end
end

print columns.join(',')
json.each do |r|
	r['tags'] = r['tags'].join(',')
	flattened = r.flatten_with_path()
	#l =	columns.map { |col|  "#{col}: #{flattened[col]}" } 
	l =	columns.map { |col|  flattened[col] } 
	puts ""
#	print l.join(',')

	csv_string = CSV.generate do |csv|
	  csv << l
	  # ...
	end

	print csv_string

#	puts "flattened: #{flattened}"
#	puts "--------------------------------"
##	puts flattened
#	columns.each do |column|
#		print "| column '#{column}':'#{flattened[column]}'," 
#	end
end



#json.each do |child|
#    puts child.keys
#end

