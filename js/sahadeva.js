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
});

/**
 * Share clickable
 */
const sharelinks = document.querySelectorAll(".sharelink");

sharelinks.forEach((link) => {
  link.addEventListener("click", () => {
    const url = link.dataset.url;
    navigator.clipboard
      .writeText(url)
      .then(showPopup("Copied to clipboard!", link))
      .catch((err) => console.error("Failed to copy to clipboard."));
  });
});

/**
 * Function that copies an input to clipboard and shows a
 * popup above the clicked element
 */
function showPopup(text, el) {
  const rect = el.getBoundingClientRect();
  const x = rect.left + window.scrollX;
  const y = rect.top + window.scrollY - 48;

  // create a popup node
  const popup = document.createElement("div");
  popup.className = "notify-popup";
  popup.textContent = text;
  document.body.appendChild(popup);
  popup.style.opacity = "1";
  popup.style.left = `${x}px`;
  popup.style.top = `${y}px`;

  setTimeout(() => {
    popup.style.opacity = "0";
    setTimeout(() => {
      popup.remove();
    }, 500);
  }, 2000);
}
