document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");

    // Create loader
    const loader = document.createElement("div");
    loader.id = "loading-overlay";
    loader.innerHTML = `
        <div class="loader-content">
            <div class="spinner"></div>
            <p>Predicting liquidity...</p>
        </div>
    `;
    document.body.appendChild(loader);

    // Show loading on form submit
    if (form) {
        form.addEventListener("submit", function () {
            loader.style.display = "flex";
        });
    }

    // Optional: scroll to result
    const result = document.querySelector("h3");
    if (result) {
        result.scrollIntoView({ behavior: "smooth" });
    }
});
