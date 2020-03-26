const resetFilters = () => {
  const reset = document.getElementById('reset');
  const selects = document.querySelectorAll('select')
  const form = document.getElementById('selects');
  console.log(selects)
  reset.addEventListener('click', (e) => {
    selects.forEach(select => {
      select.value = ""
    });
    form.submit();
  });
};

export { resetFilters };
