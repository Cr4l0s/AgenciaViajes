document.addEventListener("DOMContentLoaded", () => {
    const destinationInput = document.querySelector("input#destination");
    const suggestionsContainer = document.querySelector("#suggestions");
    const travelDateInput = document.querySelector("input#travel-date");
    const searchForm = document.querySelector("form#search-form");
    const resultsContainer = document.querySelector("#results-container");
    const leftOffer = document.querySelector("#left-offer");
    const rightOffer = document.querySelector("#right-offer");
    const csrfToken = document.querySelector("#csrf_token")?.value || "";

    // 🔹 Función para cargar y mostrar sugerencias
    async function loadDestinationSuggestions(query) {
        try {
            if (!query.trim()) {
                suggestionsContainer.textContent = "";
                return;
            }

            const response = await fetch(`Backend.php?sugerencias&query=${encodeURIComponent(query)}`, {
                method: "GET",
                headers: { "X-CSRF-Token": csrfToken }
            });

            if (!response.ok) throw new Error(`Error HTTP: ${response.status}`);

            const sugerencias = await response.json();
            suggestionsContainer.textContent = "";

            if (!Array.isArray(sugerencias) || sugerencias.length === 0) {
                const noResults = document.createElement("div");
                noResults.className = "suggestion-item";
                noResults.textContent = "No hay resultados";
                suggestionsContainer.appendChild(noResults);
                return;
            }

            sugerencias.forEach(sugerencia => {
                const suggestionElement = document.createElement("div");
                suggestionElement.className = "suggestion-item";
                suggestionElement.textContent = sugerencia.destino;
                suggestionElement.addEventListener("click", () => {
                    destinationInput.value = sugerencia.destino;
                    suggestionsContainer.textContent = "";
                });
                suggestionsContainer.appendChild(suggestionElement);
            });
        } catch (error) {
            console.error("Error al cargar sugerencias de destinos:", error);
        }
    }

    // 🔹 Evento para mostrar sugerencias en tiempo real
    destinationInput?.addEventListener("input", (event) => {
        loadDestinationSuggestions(event.target.value);
    });

    // 🔹 Ocultar sugerencias al hacer clic fuera
    document.addEventListener("click", (event) => {
        if (!destinationInput?.contains(event.target) && !suggestionsContainer?.contains(event.target)) {
            suggestionsContainer.textContent = "";
        }
    });

    // 🔹 Cargar y actualizar ofertas especiales cada 10 segundos
    async function loadScrollingOffers() {
        try {
            const response = await fetch("Backend.php?ofertas", {
                method: "GET",
                headers: { "X-CSRF-Token": csrfToken }
            });

            if (!response.ok) throw new Error(`Error HTTP: ${response.status}`);

            const ofertas = await response.json();
            if (!Array.isArray(ofertas) || ofertas.length === 0 || ofertas[0].mensaje.includes("No hay ofertas")) {
                leftOffer.textContent = "¡No hay ofertas disponibles!";
                rightOffer.textContent = "¡No hay ofertas disponibles!";
                return;
            }

            let currentIndex = 0;

            function updateOffers() {
                const ofertaLeft = ofertas[currentIndex % ofertas.length];
                const ofertaRight = ofertas[(currentIndex + 1) % ofertas.length];

                leftOffer.textContent = ofertaLeft.mensaje;
                rightOffer.textContent = ofertaRight.mensaje;

                leftOffer.classList.add("move-offer");
                rightOffer.classList.add("move-offer");

                setTimeout(() => {
                    leftOffer.classList.remove("move-offer");
                    rightOffer.classList.remove("move-offer");
                    currentIndex++;
                }, 4500);
            }

            updateOffers();
            setInterval(updateOffers, 10000);

        } catch (error) {
            console.error("Error al cargar ofertas especiales:", error);
        }
    }

    loadScrollingOffers();

    // 🔹 Buscar resultados de vuelos y hoteles
    async function searchResults(destino, fecha) {
        try {
            const response = await fetch(`Backend.php?buscar&destino=${encodeURIComponent(destino)}&fecha=${encodeURIComponent(fecha)}`, {
                method: "GET",
                headers: { "X-CSRF-Token": csrfToken }
            });

            if (!response.ok) throw new Error(`Error HTTP: ${response.status}`);

            const data = await response.json();

            console.log("Respuesta del backend:", data);

            resultsContainer.textContent = "";

            if (!data || (!Array.isArray(data.vuelos) && !Array.isArray(data.hoteles))) {
                const noResults = document.createElement("h2");
                noResults.textContent = `No se encontraron resultados para ${destino}`;
                resultsContainer.appendChild(noResults);
                resultsContainer.style.display = "block";
                return;
            }

            let vuelosHTML = "<h3><b>Vuelos Disponibles</b></h3>";
            if (Array.isArray(data.vuelos) && data.vuelos.length > 0) {
                vuelosHTML += data.vuelos.map(vuelo => `
                    <p><strong>${vuelo.aerolinea}</strong> - Precio: <b>$${vuelo.precio}</b> - Fecha: <b>${vuelo.fecha}</b></p>
                `).join('');
            } else {
                vuelosHTML += "<p>No hay vuelos disponibles.</p>";
            }

            let hotelesHTML = "<h3><b>Hoteles Recomendados</b></h3>";
            if (Array.isArray(data.hoteles) && data.hoteles.length > 0) {
                hotelesHTML += data.hoteles.map(hotel => `
                    <p><strong>${hotel.nombre}</strong> - <b>$${hotel.precio}</b> por noche</p>
                `).join('');
            } else {
                hotelesHTML += "<p>No hay hoteles disponibles.</p>";
            }

            resultsContainer.innerHTML = `
                <div class="result-box">
                    <h2 id="result-title">Resultados para ${destino}</h2>
                    ${vuelosHTML}
                    ${hotelesHTML}
                    <button class="buy-button" id="buy-button">¡Lo quiero!</button>
                </div>
            `;
            resultsContainer.style.display = "block";

            document.querySelector("#buy-button")?.addEventListener("click", () => {
                Swal.fire({
                    title: "TravelNOW!",
                    text: `¡Has seleccionado el destino: ${destino}!\nPronto nos pondremos en contacto contigo.`,
                    icon: "success",
                    confirmButtonText: "Aceptar"
                });
            });

        } catch (error) {
            console.error("Error al buscar resultados:", error);
            resultsContainer.textContent = "Hubo un error al obtener los datos.";
        }
    }

    // 🔹 Evento del formulario
    searchForm?.addEventListener("submit", (event) => {
        event.preventDefault();
        const destino = destinationInput?.value.trim();
        const fecha = travelDateInput?.value;

        if (!destino) {
            Swal.fire({ title: "TravelNOW!", text: "Por favor, ingresa un destino.", icon: "warning", confirmButtonText: "Aceptar" });
            return;
        }

        if (!fecha) {
            Swal.fire({ title: "TravelNOW!", text: "Por favor, selecciona una fecha.", icon: "warning", confirmButtonText: "Aceptar" });
            return;
        }

        searchResults(destino, fecha);
    });

    // 🔹 Función para eliminar un paquete del carrito con CSRF token
    async function eliminarDelCarrito(paqueteId) {
        try {
            const response = await fetch("carrito.php", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                    "X-CSRF-Token": csrfToken
                },
                body: `eliminar_paquete=${paqueteId}&csrf_token=${encodeURIComponent(csrfToken)}`
            });

            const result = await response.json();
            if (result.success) {
                actualizarCarrito();
            }
        } catch (error) {
            console.error("Error al eliminar del carrito:", error);
        }
    }

    async function actualizarCarrito() {
        try {
            const response = await fetch("carrito.php?ver_carrito=true", { headers: { "X-CSRF-Token": csrfToken } });
            const carrito = await response.json();
            console.log("Carrito actualizado:", carrito);
        } catch (error) {
            console.error("Error al actualizar el carrito:", error);
        }
    }
});
