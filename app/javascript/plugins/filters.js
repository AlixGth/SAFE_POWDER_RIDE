const filtersRisks = () => {
  const riskSelector = document.getElementById("risks-selector");
  if (riskSelector) {
    riskSelector.addEventListener('change', (e) => {
      console.log(riskSelector)
    })
  }
};

export { filtersRisks };
