const navbar = () => {
  const navbar = document.getElementById('navbar');
  const toggle = document.getElementById('toggle');
  const toggleIcon = document.getElementById('menu-icon');
  console.log(navbar)
  console.log(toggle)
  console.log(toggleIcon)
  toggle.addEventListener('click', (e) => {
    if (toggle.getAttribute('aria-expanded') === 'false') {
      toggleIcon.classList.add('fa-times');
      toggleIcon.classList.remove('fa-bars');
    } else {
      toggleIcon.classList.add('fa-bars');
      toggleIcon.classList.remove('fa-times');
    }
  });
};

const navbarShow = () => {
  const navbar = document.getElementById('navbar');
  const toggle = document.getElementById('toggle');
  const toggleIcon = document.getElementById('menu-icon');
  document.addEventListener("scroll", (e) => {
    if (navbar.offsetHeight < window.scrollY) {
      navbar.classList.remove('naked-navbar');
      navbar.style.position = 'fixed';
      navbar.style.width = '100%';
    } else {
      navbar.classList.add('naked-navbar');
    }
  });
  toggle.addEventListener('click', (e) => {
    if (toggle.getAttribute('aria-expanded') === 'false') {
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

export { navbar, navbarShow };
