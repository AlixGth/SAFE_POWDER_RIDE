const openUrl = () => {
  const rp = require('request-promise');
  const url = 'https://donneespubliques.meteofrance.fr/?fond=produit&id_produit=265&id_rubrique=50&fbclid=IwAR0O02tfIvgElJBsnNrOjlMJP7Rr2nNDuFNDf5ijKTf_r7Lys6V6mFLSCFc';

  rp(url)
    .then(function(html){
      //success!
      console.log(html);
    })
    .catch(function(err){
      //handle error
    });
};



// const date = document.querySelector('datepicker').value
// const massif = document.getElementById('select_massif').value
// const heure = document.getElementById('select_heures').value
// const format = 'xml'

export { openUrl };
