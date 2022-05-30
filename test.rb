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
    assert_equal(csv_file_text.to_str, sampleOutput.to_str)
  end

  def test_alternate_json_data
	sourceURL = "https://gist.githubusercontent.com/romsssss/6b8bc16cfd015e2587ef6b4c5ee0f232/raw/f74728a6ac05875dafb882ae1ec1deaae4d0ed4b/users.json"
	json_string = '[
  {
    "id": 12,
    "email": "nicolas@quintity.com",
    "tags": [
      "consectetur",
      "test",
      "plane",
      "test",
      "quis"
    ],
    "profiles": {
      "facebook": {
        "id": 12,
        "picture": "//fbcdn.com/abc.123.jpg"
      },
      "twitter": {
        "id": 12,
        "picture": "//twcdn.com/ad9e8cd3-.jpg"
      }
    }
  }
]'
  
  	  csv_string = json_to_csv(JSON.parse(json_string)).to_str.force_encoding("utf-8")
	  expected_csv_string = 'id,email,tags,profiles.facebook.id,profiles.facebook.picture,profiles.twitter.id,profiles.twitter.picture
12,nicolas@quintity.com,"consectetur,test,plane,test,quis",12,//fbcdn.com/abc.123.jpg,12,//twcdn.com/ad9e8cd3-.jpg
'.to_str.force_encoding("utf-8")
	  puts csv_string
    assert_equal(csv_string, expected_csv_string)

  end
 
end