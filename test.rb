#require_relative "main"
#require "test/unit"
#puts "Running tests"
#
#class TestSimpleNumber < Test::Unit::TestCase
# 
#  def standard_case
#	sourceURL = "https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json"
#	l = json_file_to_csv(sourceURL)
#	write_csv_to_file(l,"output.csv")
#    assert_equal(4,5 )
#  end
# 
#end
#

# File:  tc_simple_number.rb

require_relative "main"
require "test/unit"
 
class TestSimpleNumber < Test::Unit::TestCase
 
  def test_end_to_end_with_sample
	sourceURL = "https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json"
	csv_string = json_file_to_csv(sourceURL)
	path = "output.csv"
	write_csv_to_file(csv_string,path)
	csv_file_text = File.read(path)

	sampleOutputURL="https://gist.githubusercontent.com/romsssss/2efc2ace305b98be85d0fe617a10ac8b/raw/a43cffb5dc2170294e9635207f18bacba2b68001/users.csv"
	sampleOutput = HTTParty.get(sampleOutputURL)
    assert_equal(csv_file_text, sampleOutput)
  end
 
end