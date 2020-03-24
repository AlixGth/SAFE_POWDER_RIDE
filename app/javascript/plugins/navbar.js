const navbar = () => {
  const navbar = document.getElementById("navbar");
  const toggle = document.getElementById('toggle');
  document.addEventListener("scroll", (e) => {
    const map = document.getElementById("map");
    const appName = document.getElementById("app-name");
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
    console.log(toggle.classList)
    if (toggle.getAttribute('aria-expanded') === 'false') {
      // navbar.style.transition = "all 0.3s";
      navbar.classList.remove('naked-navbar');
      navbar.style.position = 'fixed';
      navbar.style.width = '100%';
    } else {
      navbar.classList.add('naked-navbar');
    }
  });
};

export { navbar };
