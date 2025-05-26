window.onload = function () {

    function normalizeaza(text) {
        if (!text) return '';
        return text.toString().toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    }

    let produse = document.getElementsByClassName("produs-item");
    for (let i = 0; i < produse.length; i++) {
        produse[i].setAttribute("data-ordine-initiala", i);
    }

    const textareaDescriere = document.getElementById("inp-descriere");
    if (textareaDescriere) {
        textareaDescriere.addEventListener('input', function () {
            if (this.value.trim().length < 3 && this.value.trim() !== '') {
                this.classList.add('is-invalid');
                this.parentElement.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
                this.parentElement.classList.remove('is-invalid');
            }
        });
    }

    let inpPret = document.getElementById("inp-pret");
    let infoRange = document.getElementById("infoRange");

    if (inpPret && infoRange) {
        inpPret.onchange = function () {
            infoRange.innerHTML = `(${this.value} RON)`;
        }
        inpPret.oninput = function () {
            infoRange.innerHTML = `(${this.value} RON)`;
        }
    }

    let btnFiltrare = document.getElementById("filtrare");
    if (btnFiltrare) {
        btnFiltrare.onclick = function () {
            let numeInput = document.getElementById("inp-nume");
            let descriereInput = document.getElementById("inp-descriere");

            let valid = true;

            if (numeInput && numeInput.value.trim() !== "") {
                if (!/^[a-zA-Z0-9\s\-_.ăâîșțĂÂÎȘȚ]+$/.test(numeInput.value.trim())) {
                    alert("Numele produsului conține caractere nepermise");
                    numeInput.style.border = "2px solid red";
                    valid = false;
                } else {
                    numeInput.style.border = "";
                }
            }

            if (descriereInput && descriereInput.value.trim() !== "") {
                if (descriereInput.value.trim().length < 3) {
                    descriereInput.classList.add('is-invalid');
                    valid = false;
                } else if (!/^[a-zA-Z0-9\s\-_.,ăâîșțĂÂÎȘȚ]+$/.test(descriereInput.value.trim())) {
                    alert("Descrierea conține caractere nepermise");
                    descriereInput.classList.add('is-invalid');
                    valid = false;
                } else {
                    descriereInput.classList.remove('is-invalid');
                }
            }

            if (!valid) return;

            let inpNume = "";
            let numeElement = document.getElementById("inp-nume");
            if (numeElement) inpNume = normalizeaza(numeElement.value.trim());

            let inpGamaPret = "toate";
            let minPret = 0;
            let maxPret = 1000000;
            let vectRadio = document.getElementsByName("gr_rad");
            if (vectRadio.length > 0) {
                for (let rad of vectRadio) {
                    if (rad.checked) {
                        inpGamaPret = rad.value;
                        if (inpGamaPret != "toate") {
                            [minPret, maxPret] = inpGamaPret.split(":");
                            minPret = parseInt(minPret);
                            maxPret = parseInt(maxPret);
                        }
                        break;
                    }
                }
            }

            let pretMin = 0;
            let pretElement = document.getElementById("inp-pret");
            if (pretElement) pretMin = pretElement.value;

            let inpCategorie = "toate";
            let categorieElement = document.getElementById("inp-categorie");
            if (categorieElement) inpCategorie = categorieElement.value.trim().toLowerCase();

            let branduriSelectate = [];
            let checkboxesBrand = document.getElementsByClassName("inp-brand-checkbox");
            for (let checkbox of checkboxesBrand) {
                if (checkbox.checked) {
                    branduriSelectate.push(checkbox.value.toLowerCase());
                }
            }

            let disponibilitatiSelectate = [];
            let checkboxes = document.getElementsByClassName("inp-disponibilitate");
            for (let checkbox of checkboxes) {
                if (checkbox.checked) {
                    disponibilitatiSelectate.push(checkbox.value);
                }
            }

            let subcategoriiSelectate = [];
            let checkboxesSubcat = document.getElementsByClassName("inp-subcategorie-checkbox");
            for (let checkbox of checkboxesSubcat) {
                if (checkbox.checked) {
                    subcategoriiSelectate.push(checkbox.value.toLowerCase());
                }
            }

            let inpDescriere = "";
            let descriereElement = document.getElementById("inp-descriere");
            if (descriereElement) inpDescriere = normalizeaza(descriereElement.value.trim());

            let caracteristiciExcluse = [];
            let selectExcludere = document.getElementById("inp-caracteristici-excluse");
            if (selectExcludere) {
                for (let i = 0; i < selectExcludere.options.length; i++) {
                    if (selectExcludere.options[i].selected) {
                        caracteristiciExcluse.push(selectExcludere.options[i].value);
                    }
                }
            }

            let datalistBrand = "";
            let datalistElement = document.getElementById("inp-brand-datalist");
            if (datalistElement) datalistBrand = datalistElement.value.trim().toLowerCase();

            let produse = document.getElementsByClassName("produs-item");
            for (let prod of produse) {
                prod.style.display = "none";

                let nume = normalizeaza(prod.querySelector("h4").innerHTML.trim());
                let cond1 = nume.includes(inpNume);

                let pret = parseFloat(prod.querySelector(".val-pret").innerHTML.trim());
                let cond2 = (inpGamaPret == "toate" || (minPret <= pret && pret < maxPret));

                let cond3 = (parseInt(pretMin) <= pret);

                let categorie = prod.querySelector(".val-categorie").innerHTML.trim().toLowerCase();
                let cond4 = (inpCategorie == "toate" || inpCategorie == categorie);

                let brand = prod.querySelector(".val-brand").innerHTML.trim().toLowerCase();
                let cond5 = branduriSelectate.length === 0 || branduriSelectate.includes(brand);

                let stocStatus = prod.querySelector(".val-stoc-status").innerHTML.trim();
                let cond6 = disponibilitatiSelectate.includes(stocStatus);

                let cond7 = true;
                if (inpDescriere) {
                    let cuvinteCautate = inpDescriere.split(/\s+/).filter(c => c.length > 0);

                    if (cuvinteCautate.length > 0) {
                        let textComplet = "";

                        let descriereElement = prod.querySelector(".descriere-entitate");
                        if (descriereElement) {
                            textComplet += " " + descriereElement.textContent.trim();
                        }

                        let caracteristiciAfisate = prod.querySelectorAll(".valoare-caracteristica");
                        caracteristiciAfisate.forEach(el => {
                            textComplet += " " + el.textContent.trim();
                        });

                        let numeElement = prod.querySelector("h4");
                        if (numeElement) {
                            textComplet += " " + numeElement.textContent.trim();
                        }

                        let dateFiltare = prod.querySelector(".val-caracteristici");
                        if (dateFiltare) {
                            textComplet += " " + dateFiltare.textContent.trim();
                        }

                        textComplet = normalizeaza(textComplet);
                        cond7 = cuvinteCautate.some(cuvant =>
                            textComplet.includes(normalizeaza(cuvant))
                        );
                    }
                }


                let subcategorie = prod.querySelector(".val-subcategorie").innerHTML.trim().toLowerCase();
                let cond8 = subcategoriiSelectate.length === 0 || subcategoriiSelectate.includes(subcategorie);

                let cond9 = true;
                let cond10 = true;

                let cond11 = true;
                if (caracteristiciExcluse.length > 0) {
                    let elemCaracteristici = prod.querySelector(".val-caracteristici");
                    if (elemCaracteristici) {
                        let caracteristiciText = elemCaracteristici.textContent.trim().toLowerCase();
                        let caracteristiciProdus = caracteristiciText.split(/\s+/);

                        cond11 = !caracteristiciExcluse.some(caracteristica =>
                            caracteristiciProdus.includes(caracteristica)
                        );
                    }
                }

                let brandDatalist = prod.querySelector(".val-brand").innerHTML.trim().toLowerCase();
                let cond12 = (datalistBrand === "" || brandDatalist.includes(datalistBrand));

                if (cond1 && cond2 && cond3 && cond4 && cond5 && cond6 && cond7 && cond8 && cond9 && cond10 && cond11 && cond12) {
                    prod.style.display = "block";
                }
            }
            let produseVizibile = 0;
            for (let prod of produse) {
                if (prod.style.display !== "none") {
                    produseVizibile++;
                }
            }

            let mesajGol = document.getElementById("mesaj-produse-goale");
            if (produseVizibile === 0) {
                if (!mesajGol) {
                    mesajGol = document.createElement("div");
                    mesajGol.id = "mesaj-produse-goale";
                    mesajGol.className = "alert alert-warning text-center";
                    mesajGol.innerHTML = `
            <h4><i class="bi bi-exclamation-triangle"></i> Nu există produse</h4>
            <p>Nu s-au găsit produse conform filtrării curente. Încercați să modificați criteriile de căutare.</p>
        `;

                    let container = document.getElementById("produse");
                    if (container) {
                        container.appendChild(mesajGol);
                    }
                }
                mesajGol.style.display = "block";
            } else {
                if (mesajGol) {
                    mesajGol.style.display = "none";
                }
            }
        }
    }

    let btnCalculeaza = document.getElementById("calculeaza");
    if (btnCalculeaza) {
        btnCalculeaza.onclick = function () {
            let produseSelectate = document.querySelectorAll(".select-produs:checked");

            if (produseSelectate.length === 0) {
                alert("Nu ați selectat niciun produs pentru calcul");
                return;
            }

            let sumaProduse = 0;
            let numarProduse = 0;

            produseSelectate.forEach(function (checkbox) {
                let produsId = checkbox.getAttribute("data-id");
                let produs = document.getElementById("ar_ent_" + produsId);

                if (produs && produs.style.display !== "none") {
                    let pret = parseFloat(produs.querySelector(".val-pret").innerHTML.trim());
                    sumaProduse += pret;
                    numarProduse++;
                }
            });

            let divRezultat = document.createElement("div");
            divRezultat.className = "rezultat-calcul";

            divRezultat.style.position = "fixed";
            divRezultat.style.top = "50%";
            divRezultat.style.left = "50%";
            divRezultat.style.transform = "translate(-50%, -50%)";
            divRezultat.style.backgroundColor = "var(--color-accent)";
            divRezultat.style.color = "white";
            divRezultat.style.padding = "2rem";
            divRezultat.style.borderRadius = "1rem";
            divRezultat.style.boxShadow = "var(--box-shadow)";
            divRezultat.style.zIndex = "9999";
            divRezultat.style.textAlign = "center";
            divRezultat.style.minWidth = "300px";
            divRezultat.style.border = "2px solid var(--color-accent-medium)";

            divRezultat.innerHTML = `
                <h4 style="margin-bottom: 1rem; color: white;">🧮 Calcul Produse</h4>
                <p style="margin: 0; font-size: 1.1rem;">
                    Suma produselor selectate:<br>
                    <strong style="font-size: 1.3rem;">${sumaProduse.toFixed(2)} RON</strong>
                    <br><small>(${numarProduse} produse selectate)</small>
                </p>`;

            document.body.appendChild(divRezultat);

            setTimeout(function () {
                if (divRezultat && divRezultat.parentNode) {
                    divRezultat.remove();
                }
            }, 2000);
        }
    }
    // buton reset
    let btnResetare = document.getElementById("resetare");
    if (btnResetare) {
        btnResetare.onclick = function () {
            if (confirm("Doriți să resetați toate filtrele?")) {
                let numeInput = document.getElementById("inp-nume");
                if (numeInput) numeInput.value = "";

                let pretInput = document.getElementById("inp-pret");
                if (pretInput) pretInput.value = 0;

                let infoRange = document.getElementById("infoRange");
                if (infoRange) infoRange.innerHTML = "(0 RON)";

                let datalistInput = document.getElementById("inp-brand-datalist");
                if (datalistInput) datalistInput.value = "";

                let radioBtnToate = document.getElementById("i_rad4");
                if (radioBtnToate) radioBtnToate.checked = true;

                let categorieSelect = document.getElementById("inp-categorie");
                if (categorieSelect) categorieSelect.value = "toate";

                let descriereInput = document.getElementById("inp-descriere");
                if (descriereInput) descriereInput.value = "";

                let checkboxes = document.getElementsByClassName("inp-disponibilitate");
                for (let checkbox of checkboxes) {
                    checkbox.checked = true;
                }

                let checkboxesBrand = document.getElementsByClassName("inp-brand-checkbox");
                for (let checkbox of checkboxesBrand) {
                    checkbox.checked = true;
                }

                let checkboxesSubcat = document.getElementsByClassName("inp-subcategorie-checkbox");
                for (let checkbox of checkboxesSubcat) {
                    checkbox.checked = true;
                }

                let selectExcludere = document.getElementById("inp-caracteristici-excluse");
                if (selectExcludere) {
                    for (let i = 0; i < selectExcludere.options.length; i++) {
                        selectExcludere.options[i].selected = false;
                    }
                }

                let produse = document.getElementsByClassName("produs-item");
                for (let prod of produse) {
                    prod.style.display = "block";
                }

                let mesajGol = document.getElementById("mesaj-produse-goale");
                if (mesajGol) {
                    mesajGol.style.display = "none";
                }
            }
        }
    }

    let btnSortCrescPret = document.getElementById("sortCrescPret");
    if (btnSortCrescPret) {
        btnSortCrescPret.onclick = function () {
            sortareProduse(true);
        }
    }

    let btnSortDescrescPret = document.getElementById("sortDescrescPret");
    if (btnSortDescrescPret) {
        btnSortDescrescPret.onclick = function () {
            sortareProduse(false);
        }
    }

    function sortareProduse(crescator) {
        let container = document.getElementById("produse");
        if (!container) return;

        let produse = Array.from(container.getElementsByClassName("produs-item"));

        produse.sort(function (a, b) {
            let subcategorieA = a.querySelector(".val-subcategorie").innerHTML.trim().toLowerCase();
            let subcategorieB = b.querySelector(".val-subcategorie").innerHTML.trim().toLowerCase();

            if (subcategorieA < subcategorieB) return crescator ? -1 : 1;
            if (subcategorieA > subcategorieB) return crescator ? 1 : -1;

            let pretA = parseFloat(a.querySelector(".val-pret").innerHTML.trim());
            let pretB = parseFloat(b.querySelector(".val-pret").innerHTML.trim());

            return crescator ? pretA - pretB : pretB - pretA;
        });

        for (let prod of produse) {
            container.appendChild(prod);
        }
    }
};

window.onkeydown = function (e) {
    if (e.key == "c" && e.altKey) {
        let produse = document.getElementsByClassName("produs-item");
        let sumaPreturi = 0;
        let produseVizibile = 0;

        for (let prod of produse) {
            if (prod.style.display != "none") {
                let pret = parseFloat(prod.querySelector(".val-pret").innerHTML.trim());
                sumaPreturi += pret;
                produseVizibile++;
            }
        }

        let elementExistent = document.getElementById("suma_preturi");
        if (elementExistent) {
            elementExistent.remove();
        }

        let divRezultat = document.createElement("div");
        divRezultat.id = "suma_preturi";

        divRezultat.style.position = "fixed";
        divRezultat.style.top = "20px";
        divRezultat.style.right = "20px";
        divRezultat.style.backgroundColor = "var(--color-main)";
        divRezultat.style.color = "var(--color-text)";
        divRezultat.style.padding = "1rem";
        divRezultat.style.borderRadius = "0.5rem";
        divRezultat.style.boxShadow = "var(--box-shadow)";
        divRezultat.style.zIndex = "9999";
        divRezultat.style.border = "2px solid var(--color-accent)";
        divRezultat.style.minWidth = "250px";

        divRezultat.innerHTML = `
            <p style="margin: 0; text-align: center;">
                <strong>🔥 Suma totală vizibilă:</strong><br>
                <span style="font-size: 1.2rem; color: var(--color-accent);">${sumaPreturi.toFixed(2)} RON</span><br>
                <small>(${produseVizibile} produse afișate)</small>
            </p>`;

        document.body.appendChild(divRezultat);

        setTimeout(function () {
            let p1 = document.getElementById("suma_preturi");
            if (p1) {
                p1.remove();
            }
        }, 3000);
    }
}