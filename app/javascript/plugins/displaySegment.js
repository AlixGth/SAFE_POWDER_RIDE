import mapboxgl from 'mapbox-gl';

const extractArray = () => {
  let coordinates = document.getElementById("hidden").dataset.waypoints;
  let array = []
  coordinates = coordinates.split("],").forEach((coordinate) => {
    const qwe = coordinate.split("\"").join("").split("[").join("").split(",");
    let lng = Number.parseFloat(qwe[1].trim(), 10);
    let lat = Number.parseFloat(qwe[2].trim(), 10);
    array.push([lng, lat, qwe[3], qwe[4]]);
  });
  return array;
};

const getLats = (wp) => {
  let lats = [];
  wp.forEach((points) => {
    lats.push(points[1]);
  });
  return lats;
};

const getLngs = (wp) => {
  let lngs = [];
  wp.forEach((points) => {
    lngs.push(points[0]);
  });
  return lngs;
};

const getMinMax = (waypoints) => {
  const padding = 0.005;
  const lats = getLats(waypoints);
  const lngs = getLngs(waypoints);
  const minLat = Math.min(...lats) - padding;
  const maxLat = Math.max(...lats) + padding;
  const minLng = Math.min(...lngs) - padding;
  const maxLng = Math.max(...lngs) + padding;
  return [[maxLng, minLat],[minLng, maxLat]];
};

const display = (map, route, name, color, evolColor) => {
  // [[lng1, lat1],[lng2, lat2], [lng3, lat3]]
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
  map.addLayer({
    'id': name.concat("Evolution"),
    'type': 'line',
    'source': name,
    'layout': {
      'line-join': 'round',
      'line-cap': 'round',
      'visibility': 'none'
    },
    'paint': {
      'line-color': evolColor,
      'line-width': 3
    }
  });
};

const toggleLayer = (map, coordinatesIds) => {
  // const link = document.createElement('a');
  // link.href = '#';
  // link.className = '';
  // link.textContent = 'Evolution';
  const evolRiskCheck = document.getElementById('evolRiskCheck');

  evolRiskCheck.addEventListener('change', (event) => {

    for (const element of coordinatesIds) {
      const visibility = map.getLayoutProperty(element.concat("Evolution"), 'visibility');

      if (evolRiskCheck.checked) {
        map.setLayoutProperty(element.concat("Evolution"), 'visibility', 'visible');
      } else {
        map.setLayoutProperty(element.concat("Evolution"), 'visibility', 'none');
      }
    }
  });
};

const addPoint = (map) => {
  const altLng = Number.parseFloat(document.getElementById("hidden").dataset.altlng, 10)
  const altLat = Number.parseFloat(document.getElementById("hidden").dataset.altlat, 10)
  const geojson = {
    type: 'FeatureCollection',
      features: [{
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [altLng, altLat]
        },
        properties: {
          title: 'Différence de risque',
          description: 'Washington, D.C.'
        }
      }]
  }

  geojson.features.forEach(function(marker) {

    // create a HTML element for each feature
    var el = document.createElement('div');
    el.className = 'marker';

    // make a marker for each feature and add to the map
    new mapboxgl.Marker(el)
      .setLngLat(marker.geometry.coordinates)
      .setPopup(new mapboxgl.Popup({ offset: 25 }) // add popups
          .setHTML('<h6>' + marker.properties.title + '</h6><p>' + marker.properties.description + '</p>'))
      .addTo(map);
  });
};

const displayRoute = () => {
  const coordinatesIds = []
  const evolRisk = document.getElementById("hidden").dataset.evolrisk === "true";
  if (document.getElementById("map")){
    mapboxgl.accessToken = document.getElementById("map").dataset.mapboxApiKey;
    const waypoints = extractArray();
    var map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/outdoors-v11?optimize=true',
      center: [waypoints[0][0], waypoints[0][1]],
      zoom: 15
    });
    map.fitBounds(getMinMax(waypoints));
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
        const evolColor = waypoints[i][3];
        coordinatesIds.push(i.toString())
        display(map, [[lng0, lat0], [lng1, lat1], [lng2, lat2], [lng3, lat3], [lng4, lat4]], i.toString(), color, evolColor);
      };
    addPoint(map);
    });
    if (evolRisk) {
      toggleLayer(map, coordinatesIds);
    }
    // console.log(waypoints[0][0]);
  }
};

export { displayRoute };
