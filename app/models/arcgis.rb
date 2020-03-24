require 'json'
require 'net/http'
response = Net::HTTP.post_form URI('https://www.arcgis.com/sharing/rest/oauth2/token'),
  f: 'json',
  client_id: 'xosPPt3elLCXA8tk',
  client_secret: '903d4a22e4db48e39ccedaea8e3f7c18',
  grant_type: 'client_credentials'
token = JSON.parse(response.body)['access_token']
def test(url, features, token)
    enrich = Net::HTTP.post_form(URI(url),
    token: token,
    InputFeatures: {
      "spatialReference": {
        "wkid": 4326
      },
      "fields": [
        {
          "alias": "OBJECTID",
          "name": "OBJECTID",
          "type": "esriFieldTypeOID",
          "editable": false
        }
      ],
      "objectIdField": "OBJECTID",
      "geometryType": "esriGeometryPoint",
      "features": [
        {
          "geometry": {
            "x": -118.24274,
            "y": 34.05369,
            "spatialReference": {
              "wkid": 4326
            }
          },
          "attributes": {
            "OBJECTID": 1,
            "name": "LA City Hall",
            "address": "200 N Spring St, Los Angeles, CA 90012"
          }
        }
      ]
    })
    return JSON.parse(enrich.body)
end
url = "http://elevation.arcgis.com/arcgis/rest/services/Tools/Elevation/GPServer/SummarizeElevation/submitJob"
features = [{
  "geometry": {
    "x": -118.24274,
    "y": 34.05369,
    "spatialReference": {
      "wkid": 4326
    }
  },
  "attributes": {
    "name": "LA City Hall",
    "address":"200 N Spring St, Los Angeles, CA 90012"
  }
}]
test(url, features, token)


  require 'json'
    require 'net/http'

    enrich = Net::HTTP.post_form URI('http://geoenrich.arcgis.com/arcgis/rest/services/World/GeoenrichmentServer/Geoenrichment/enrich'),
      f: 'json',
      token: 'J-S0KLOl5_8UIqzZfmjPp6KQQeN5rnDRxRKB73n7B2hxuuI6Fec09IsIk0n8a0j-LoBskkio0I5fL0sY5iLf1J8lfhgq1gdaOAB15sm2wEaRooZbWz87bWptfGOMlqfFCoGRwF9n0h3tOd21lMyB9g..',
      studyAreas: '[{"geometry":{"x":-117.1956,"y":34.0572}}]'

    puts JSON.parse(enrich.body)
