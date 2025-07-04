const slider = document.getElementById("abstracts-slider");
const langSelector = document.getElementById("lang-selector");
const langButtons = langSelector?.querySelectorAll("button");

if (langButtons) langButtons[0].dataset.selected = "true";

function showAbstract(index, el) {
  if (!slider) return;
  slider.style.transform = `translateX(-${index * 100}%)`;
  langButtons.forEach((button) => (button.dataset.selected = "false"));
  el.dataset.selected = "true";
}
