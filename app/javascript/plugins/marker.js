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
  const risk1 = document.getElementById("hidden").dataset.risk1;
  const riskData1 = getRiskData(risk1);
  const risk2 = document.getElementById("hidden").dataset.risk2;
  const riskData2 = getRiskData(risk2);
  const evolRisk1 = document.getElementById("hidden").dataset.evolrisk1;
  const evolriskData1 = getRiskData(evolRisk1);
  const evolRisk2 = document.getElementById("hidden").dataset.evolrisk2;
  const evolriskData2 = getRiskData(evolRisk2);

  const html = `<div><p class= "risk-level-infos" style="background-color: #${riskData2[1]}">${riskData2[0]}</p><i class="fas fa-chevron-up"></i><p class="m-0">Alt. limite: ${altitudeInfo}</p><i class="fas fa-chevron-down"></i><p class= "risk-level-infos" style="background-color: #${riskData1[1]}">${riskData1[0]}</p></div>`
  const htmlEvol = `<div><p class= "risk-level-infos"style="background-color: #${evolriskData2[1] || riskData2[1]}">${evolriskData2[0] || riskData2[0]}</p><i class="fas fa-chevron-up"></i><p class="m-0">Alt. limite: ${altitudeInfo}</p><i class="fas fa-chevron-down"></i><p class= "risk-level-infos" style="background-color: #${evolriskData1[1] || riskData1[1]}">${evolriskData1[0] || riskData1[0]}</p></div>`

  const popup = new mapboxgl.Popup({ offset: 25 }).setHTML(html);
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
