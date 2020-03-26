import mapboxgl from 'mapbox-gl';

const evolRiskCheck = document.getElementById('evolRiskCheck');

const getRiskData = (risk) => {
  const riskData = risk.match(/(\w+)/g)
  if (riskData[0] === "nil") { riskData[0] = null }
  if (riskData[1] === "nil") { riskData[1] = null }
  return [Number(riskData[0]), riskData[1]]
};

const addPoint = (map) => {
  const altLng = Number.parseFloat(document.getElementById("hidden").dataset.altlng, 10);
  const altLat = Number.parseFloat(document.getElementById("hidden").dataset.altlat, 10);
  const altitudeInfo = document.getElementById("hidden").dataset.infoaltitude;
  const risk1 = Number(document.getElementById("hidden").dataset.risk1);
  const risk2 = Number(document.getElementById("hidden").dataset.risk2);
  const evolRisk1 = Number(document.getElementById("hidden").dataset.evolrisk1);
  const evolRisk2 = Number(document.getElementById("hidden").dataset.evolrisk2);

  const html = `<h6>Différence de risque</h6><div><p class="m-0">Risque ${risk2}</p><p class="m-0">Altitude limite: ${altitudeInfo}</p><p class="m-0">Risque ${risk1}</p></div>`
  const htmlEvol = `<h6>Différence de risque</h6><div><p class="m-0">Risque ${evolRisk2 || risk2}</p><p class="m-0">Altitude limite: ${altitudeInfo}</p><p class="m-0">Risque ${evolRisk1 || risk1}</p></div>`

  const popup = new mapboxgl.Popup().setHTML(html);
    // Create a HTML element for your custom marker
    const element = document.createElement('div');
    element.className = 'marker';
    // Pass the element as an argument to the new marker
    new mapboxgl.Marker(element)
      .setLngLat([altLng, altLat])
      .setPopup(popup)
      .addTo(map);

  evolRiskCheck.addEventListener('change', (event) => {
    if (evolRiskCheck.checked) {
      popup.setHTML(htmlEvol);
    } else {
      popup.setHTML(html);
    }
  });
};

export { addPoint, getRiskData };
