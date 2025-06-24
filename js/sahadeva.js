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

/**
 * Burger menu admin logic
 */
const adminExpandBtn = document.getElementById("admin-expand-btn");
const expandedMenu = document.getElementById("user-expanded");

if (adminExpandBtn) {
  adminExpandBtn.addEventListener("click", (ev) => {
    const isExpanded = ev.target.dataset.expanded;

    if (isExpanded === "false") {
      expandedMenu.classList.add("expanded");
      ev.target.dataset.expanded = "true";
    } else {
      expandedMenu.classList.remove("expanded");
      ev.target.dataset.expanded = "false";
    }
  });
}

/**
 * Monetag logic
 */

const monetagCTA = document.getElementById("view-ad");

if (monetagCTA) {
  defocus.style.zIndex = 10000;
  defocus.classList.add("defocus");
}

monetagCTA.addEventListener("click", () => {
  const adArray = [
    "https://otieu.com/4/9483189",
    "https://otieu.com/4/9483045",
  ];
  const theAdUrl = adArray[Math.floor(Math.random() * adArray.length)];

  window.open(
    theAdUrl,
    "_blank",
    "width=800,height=600,resizable=yes,scrollbars=yes"
  );
  monetagCTA.parentElement.parentElement.remove();
  defocus.style.zIndex = 99;
  defocus.classList.remove("defocus");
});
