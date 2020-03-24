const navbar = () => {
  const navbar = document.getElementById('navbar');
  const toggle = document.getElementById('toggle');
  const toggleIcon = document.getElementById('menu-icon');
  console.log(document);
  document.addEventListener("scroll", (e) => {
    const map = document.getElementById("map");
    if (map) {
      if (navbar.offsetHeight < window.scrollY) {
        // navbar.style.transition = "all 0.3s";
        navbar.classList.remove('naked-navbar');
        navbar.style.position = 'fixed';
        navbar.style.width = '100%';
      } else {
        navbar.classList.add('naked-navbar');
      }
    }
  });
  toggle.addEventListener('click', (e) => {
    if (toggle.getAttribute('aria-expanded') === 'false') {
      // navbar.style.transition = "all 0.3s";
      navbar.classList.remove('naked-navbar');
      navbar.style.position = 'fixed';
      navbar.style.width = '100%';
      toggleIcon.classList.add('fa-times');
      toggleIcon.classList.remove('fa-bars');
    } else {
      navbar.classList.add('naked-navbar');
      toggleIcon.classList.add('fa-bars');
      toggleIcon.classList.remove('fa-times');
    }
  });
};

export { navbar };
