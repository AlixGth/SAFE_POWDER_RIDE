const navbar = () => {
  document.addEventListener("scroll", (e) => {
    const map = document.getElementById("map");
    const navbar = document.getElementById("navbar");
    if (map) {
      if (navbar.offsetHeight < window.scrollY) {
        navbar.style.backgroundColor = "rgb(38, 109, 211)";
      } else {
        navbar.style.backgroundColor = "rgba(0,0,0,0)";
      }
    }
  });
};

export { navbar };
