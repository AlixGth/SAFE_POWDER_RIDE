const fixFooter = () => {
  document.addEventListener("DOMContentLoaded", function (event) {
    var element = document.querySelector('body');
    var height = element.offsetHeight;
    if (height <= window.innerHeight) {
      document.getElementById("footer").classList.add('stikybottom');
    }
  }, false);
};

export { fixFooter };
