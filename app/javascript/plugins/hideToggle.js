const carousel = document.getElementById('carouselExampleControls');
const toggle = document.getElementById('menu');
const map = document.getElementById('map');
const right = document.querySelector('.carousel-control-next');
const left = document.querySelector('.carousel-control-prev');


const toggleClass = () => {
  console.log("hello");
  if (map.classList.contains('active')) {
    toggle.classList.remove('d-none')
    toggle.classList.add('d-flex')
  } else {
    toggle.classList.add('d-none')
    toggle.classList.remove('d-flex')
  }
};

const hideToggle = () => {
  right.onclick = toggleClass;
  left.onclick = toggleClass;
};

export { hideToggle };


