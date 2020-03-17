import mapboxgl from 'mapbox-gl';

mapboxgl.accessToken = document.getElementById("map").dataset.mapboxApiKey;

const extractArray = () => {
  let coordinates = document.getElementById("hidden").dataset.waypoints;
  let array = []
  coordinates = coordinates.split("],").forEach((yes) => {
    const qwe = yes.split("\"").join("").split("[").join("").split(",");
    let lng = Number.parseFloat(qwe[0].trim(), 10);
    let lat = Number.parseFloat(qwe[1].trim(), 10);
    let ele = Number.parseFloat(qwe[2].trim(), 10);
    let color = qwe[3].trim();
    array.push([lng, lat, ele, color]);
  });
  return array;
};

const waypoints = extractArray();

var map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/mapbox/outdoors-v11',
  center: [waypoints[0][0], waypoints[0][1]],
  zoom: 20
});


const display = (route, name, color) => {
  console.log(color);
  map.addSource(name, {
    'type': 'geojson',
    'data': {
      'type': 'Feature',
      'properties': {},
      'geometry': {
        'type': 'LineString',
        'coordinates': route // [[lng, lat],[lng, lat]]
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
      'line-width': 2
    }
  });
};

const displayRoute = () => {
  map.on("click", function(e) {
    for(let i = 1; i < waypoints.length - 1; i++) {
      const lng1 = waypoints[i-1][0];
      const lat1 = waypoints[i-1][1];
      const lng2 = waypoints[i][0];
      const lat2 = waypoints[i][1];
      const color = waypoints[i][3];
      display([[lng1, lat1],[lng2, lat2]], i.toString(), color);
    };
  });
};

export { displayRoute };