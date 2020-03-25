import mapboxgl from 'mapbox-gl';
import MapboxCircle from 'mapbox-gl-circle';

const extractArray = () => {
  let coordinates = document.getElementById("hidden").dataset.waypoints;
  let array = []
  coordinates = coordinates.split("],").forEach((coordinate) => {
    const qwe = coordinate.split("\"").join("").split("[").join("").split(",");
    let lng = Number.parseFloat(qwe[1].trim(), 10);
    let lat = Number.parseFloat(qwe[2].trim(), 10);
    let slope = Number.parseFloat(qwe[5].trim(), 10);
    array.push([lng, lat, qwe[3], qwe[4], slope]);
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

const evolRiskCheck = document.getElementById('evolRiskCheck');
const toggleLayer = (map, coordinatesIds) => {
  // const link = document.createElement('a');
  // link.href = '#';
  // link.className = '';
  // link.textContent = 'Evolution';

  evolRiskCheck.addEventListener('change', (event) => {
    const switchStatus = document.getElementById('switch-status');
    if (switchStatus.innerText == "Après-midi"){
      switchStatus.innerText = "Matin";
    } else {
      switchStatus.innerText = "Après-midi";
    }
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
  const altLng = Number.parseFloat(document.getElementById("hidden").dataset.altlng, 10);
  const altLat = Number.parseFloat(document.getElementById("hidden").dataset.altlat, 10);
  const altitudeInfo = document.getElementById("hidden").dataset.infoaltitude;
  const risk1 = Number(document.getElementById("hidden").dataset.risk1);
  const risk2 = Number(document.getElementById("hidden").dataset.risk2);
  const evolRisk1 = Number(document.getElementById("hidden").dataset.evolrisk1);
  const evolRisk2 = Number(document.getElementById("hidden").dataset.evolrisk2);
  const geojson = {
    id: 'altRisk',
    type: 'FeatureCollection',
      features: [{
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [altLng, altLat]
        },
        properties: {
          title: 'Différence de risque'
        }
      }]
  }

  geojson.features.forEach(function(marker) {

    // create a HTML element for each feature
    const el = document.createElement('div');
    el.className = 'marker';

    const html = `<h6> ${marker.properties.title}</h6><div><p class="m-0">Risque ${risk2}</p><p class="m-0">Altitude limite: ${altitudeInfo}</p><p class="m-0">Risque ${risk1}</p></div>`
    const htmlEvol = `<h6> ${marker.properties.title}</h6><div><p class="m-0">Risque ${evolRisk2 || risk2}</p><p class="m-0">Altitude limite: ${altitudeInfo}</p><p class="m-0">Risque ${evolRisk1 || risk1}</p></div>`

    const pop = new mapboxgl.Popup({ offset: 25 })
    // make a marker for each feature and add to the map
    new mapboxgl.Marker(el)
      .setLngLat(marker.geometry.coordinates)
      .setPopup(pop // add popups
          .setHTML(html))
      .addTo(map);

    evolRiskCheck.addEventListener('change', (event) => {
      if (evolRiskCheck.checked) {
        pop.setHTML(htmlEvol);
      } else {
        pop.setHTML(html);
      }
    });
  });
};

const getMaxSlopeRisk = riskLevel => {
  switch(riskLevel) {
    case 1:
      return 40
    case 2:
      return 35
    case 3:
      return 30
  }
};

const applySlopes = (map, slopes, riskLevel) => {
  const maxSlope = getMaxSlopeRisk(riskLevel);
  slopes.forEach(slope => {
    if (slope[4] >= maxSlope) {
      let circle = new MapboxCircle({lat: slope[1], lng: slope[0]}, slope[4] + 10, {
          editable: false,
          minRadius: 1500,
          fillColor: '#FF0000'
      }).addTo(map)
    }
  });
};

const displayDanger = () => {
  const htmlElement = "<div class='d-flex justify-content-around'><i class='fas fa-exclamation-circle' style='color: red; font-size: 30px'></i><h4>Cet itinéraire semble trop dangereux dans les conditions actuelles!</h4><i class='fas fa-exclamation-circle' style='color: red; font-size: 30px'></i></div>"
  document.getElementById("itinerary-title").insertAdjacentHTML('afterend', htmlElement);
};

const displayRoute = () => {
  const coordinatesIds = []

  if (document.getElementById("map")){
    const evolRisk = document.getElementById("hidden").dataset.evolrisk === "true";
    const altitude = document.getElementById("hidden").dataset.altitude === "true";
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
      const riskMax = Number.parseInt(document.getElementById('risk_max').innerText, 10);
      if (riskMax > 3){
        displayDanger();
      } else {
        applySlopes(map, waypoints, riskMax);
      }
      if (altitude) {
        addPoint(map);
      }
    });
    if (evolRisk) {
      toggleLayer(map, coordinatesIds);
    }
  }
};

export { displayRoute };
