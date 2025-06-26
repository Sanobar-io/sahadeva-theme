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
const popupEl = document.getElementById("popup");
const monetagCTA = document.getElementById("view-ad");

if (monetagCTA && popupEl) {
  showAdPopup();
  setInterval(showAdPopup, 1000);
}

function showAdPopup() {
  const lastClick = localStorage.getItem("lastAdClick");
  const now = Date.now();

  // check if it's been 5 minutes (300,000ms)
  if (!lastClick || now - parseInt(lastClick, 10) > 5 * 60 * 1000) {
    popupEl.dataset.hidden = "false";
  } else {
    popupEl.dataset.hidden = "true";
  }
}

monetagCTA?.addEventListener("click", () => {
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

  localStorage.setItem("lastAdClick", now);
  popupEl.dataset.hidden = "true";
});

/**
 * Share clickable
 */
const sharelinks = document.querySelectorAll(".sharelink");
const seeViews = document.querySelectorAll(".see-views");

seeViews.forEach((el) => {
  el.addEventListener("click", () => {
    const text = el.dataset.text;
    showPopup(text, el);
  });
});

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
  // remove existing popups
  const existingPopup = document.querySelector(".notify-popup");
  if (existingPopup) {
    existingPopup.remove();
  }

  const rect = el.getBoundingClientRect();
  const x = rect.left + window.scrollX + 12;
  const y = rect.top + window.scrollY - 36;

  // create a popup node
  const popup = document.createElement("div");
  popup.className = "notify-popup";
  popup.textContent = text;
  document.body.appendChild(popup);
  popup.style.opacity = "1";
  popup.style.left = `${x}px`;
  popup.style.top = `${y}px`;

  el.style.pointerEvents = "none";

  setTimeout(() => {
    popup.style.opacity = "0";
    setTimeout(() => {
      popup.remove();
      el.style.pointerEvents = "auto";
    }, 500);
  }, 2000);
}
