import mapboxgl from 'mapbox-gl';

mapboxgl.accessToken = document.getElementById("map").dataset.mapboxApiKey;

const extractArray = () => {
  let coordinates = document.getElementById("hidden").dataset.waypoints;
  let array = []
  coordinates = coordinates.split("],").forEach((yes) => {
    const qwe = yes.split("\"").join("").split("[").join("").split(",");
    let lng = Number.parseFloat(qwe[1].trim(), 10);
    let lat = Number.parseFloat(qwe[2].trim(), 10);
    if (qwe[3]){
      array.push([lng, lat, qwe[3]])
    } else {
      array.push([lng, lat])
    }
  });
  console.log(array)
  return array;
};

const waypoints = extractArray();

var map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/mapbox/outdoors-v11?optimize=true',
  center: [waypoints[0][0], waypoints[0][1]],
  zoom: 15
});


const display = (route, name, color) => {
  // [[lng1, lat1],[lng2, lat2], [lng3, lat3]]
  console.log(color);
  map.addSource(name, {
    'type': 'geojson',
    'data': {
      'type': 'Feature',
      'properties': {},
      'geometry': {
        'type': 'MultiLineString',
        'coordinates': [
          [route[0], route[1]],
          [route[1], route[2]],
          [route[2], route[3]],
          [route[3], route[4]]
        ]
      }
    }
  });
  map.addLayer({
    'id': name,
    'type': 'line',
    'source': name,
    'layout': {
      'line-join': 'round',
      'line-cap': 'round'
    },
    'paint': {
      'line-color': color,
      'line-width': 3
    }
  });
};

const displayRoute = () => {
  if (document.getElementById("map")){
    console.log(waypoints);
    map.on("load", function(e) {
      for(let i = 4; i < waypoints.length - 1; i = i + 4) {
        const lng0 = waypoints[i-4][0];
        const lat0 = waypoints[i-4][1];
        const lng1 = waypoints[i-3][0];
        const lat1 = waypoints[i-3][1];
        const lng2 = waypoints[i-2][0];
        const lat2 = waypoints[i-2][1];
        const lng3 = waypoints[i-1][0];
        const lat3 = waypoints[i-1][1];
        const lng4 = waypoints[i][0];
        const lat4 = waypoints[i][1];
        const color = waypoints[i][2];
        display([[lng0, lat0], [lng1, lat1], [lng2, lat2], [lng3, lat3], [lng4, lat4]], i.toString(), color);
      };
    });
  }
};

export { displayRoute };