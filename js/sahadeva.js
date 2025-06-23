/**
 * Burger menu animations and styling
 */

const burgerBtn = document.getElementById("burger-menu-btn");
const mobileMenu = document.getElementById("mobile-menu");
const defocus = document.getElementById("defocus");

burgerBtn.addEventListener("click", (ev) => {
  const toggleBeforeClick = ev.target.dataset && ev.target.dataset.toggle;

  if (toggleBeforeClick === "true") {
    defocus.classList.remove("defocus");
    mobileMenu.classList.remove("show");
    ev.target.dataset.toggle = "false";
  } else {
    defocus.classList.add("defocus");
    mobileMenu.classList.add("show");
    ev.target.dataset.toggle = "true";
  }
});

document.addEventListener("click", (ev) => {
  const toggleBeforeClick = burgerBtn.dataset && burgerBtn.dataset.toggle;

  if (toggleBeforeClick === "false") return;

  const clickedOutside =
    !mobileMenu.contains(ev.target) && !burgerBtn.contains(ev.target); // clicked outside of menu

  if (clickedOutside) {
    defocus.classList.remove("defocus");
    burgerBtn.dataset.toggle = "false";
    mobileMenu.classList.remove("show");
  }
});
