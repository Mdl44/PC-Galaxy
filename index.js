const express = require("express"); // server
const path = require("path"); //path-uri de foldere
const fs = require("fs"); // fisiere
const sharp = require("sharp"); //imagini
const sass = require("sass"); // pentru compilare SCSS in CSS
const pg = require("pg"); //baza de date postgresql

//const AccesBD = require("./module_proprii/accesbd.js")

//baza de date 
const Client = pg.Client;

client = new Client({
    database: "proiect",
    user: "madalin",
    password: "madalin",
    host: "localhost",
    port: 5432
})

app = express(); // obiect server express

app.set("view engine", "ejs"); //ejs ca template 

const T = 2;
const T2 = 5;
const caleFisierOferte = path.join(__dirname, "resurse/json/oferte.json");

//variabile globale
obGlobal = {
    obErori: null,
    obimagini: null,
    folderScss: path.join(__dirname, "resurse/scss"),
    folderCss: path.join(__dirname, "resurse/css"),
    folderBackup: path.join(__dirname, "backup"),
    optiuniMeniu: null,
    categorii: [],
    oferte: []
}

function incarcaCategorii() {
    const queryCategorii = "SELECT unnest(enum_range(NULL::categoria_principala)) AS categorie";
    client.query(queryCategorii, function (err, rezCategorii) {
        if (err) {
            console.log("Eroare la încărcarea categoriilor pentru oferte:", err);
            obGlobal.categorii = [];
        } else {
            obGlobal.categorii = rezCategorii.rows.map(row => row.categorie);
            console.log("Categorii încărcate pentru oferte:", obGlobal.categorii);
        }
    });
}

function genereazaOferta() {
    console.log("=== Generare nouă ofertă ===");
    console.log("Categorii disponibile:", obGlobal.categorii);
    
    if (!obGlobal.categorii || obGlobal.categorii.length === 0) {
        console.warn("Nu există categorii în obGlobal. Se încearcă reîncărcarea...");
        incarcaCategorii();
        return;
    }

    let oferteJson;
    
    try {
        const continutFisier = fs.readFileSync(caleFisierOferte, 'utf8');
        oferteJson = JSON.parse(continutFisier);
    } catch (e) {
        console.warn("Fișierul oferte.json nu există sau este corupt. Se va crea unul nou.");
        oferteJson = { oferte: [] };
    }

    if (!oferteJson.oferte) {
        oferteJson.oferte = [];
    }

    let ultimaCategorie = oferteJson.oferte.length > 0 ? oferteJson.oferte[0].categorie : null;
    let categoriiDisponibile = obGlobal.categorii.filter(c => c !== ultimaCategorie);

    if (categoriiDisponibile.length === 0) {
        console.warn("Nu există categorii diferite de ultima ofertă. Se permite repetarea.");
        categoriiDisponibile = obGlobal.categorii;
    }

    const categorieAleasa = categoriiDisponibile[Math.floor(Math.random() * categoriiDisponibile.length)];

    const reduceri = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
    const reducere = reduceri[Math.floor(Math.random() * reduceri.length)];

    const dataIncepere = new Date();
    const dataFinalizare = new Date(dataIncepere.getTime() + T * 60000);

    const ofertaNoua = {
        categorie: categorieAleasa,
        reducere: reducere,
        "data-incepere": dataIncepere.toISOString(),
        "data-finalizare": dataFinalizare.toISOString()
    };

    oferteJson.oferte.unshift(ofertaNoua);

    const limitaEliminare = new Date(Date.now() - T2 * 60000);
    const oferteleInitiale = oferteJson.oferte.length;
    
    oferteJson.oferte = oferteJson.oferte.filter(oferta => {
        const dataFinalizareOferta = new Date(oferta["data-finalizare"]);
        return dataFinalizareOferta > limitaEliminare;
    });

    const oferteleEliminateCount = oferteleInitiale - oferteJson.oferte.length;
    if (oferteleEliminateCount > 0) {
        console.log(`Eliminate ${oferteleEliminateCount} oferte vechi`);
    }

    try {
        fs.writeFileSync(caleFisierOferte, JSON.stringify(oferteJson, null, 2));
        obGlobal.oferte = oferteJson.oferte;
        
        console.log("Ofertă generată cu succes:", {
            categorie: ofertaNoua.categorie,
            reducere: ofertaNoua.reducere + "%",
            dataIncepere: dataIncepere.toLocaleString('ro-RO'),
            dataFinalizare: dataFinalizare.toLocaleString('ro-RO')
        });
        console.log(`Total oferte active: ${oferteJson.oferte.length}`);
    } catch (error) {
        console.error("Eroare la salvarea fișierului oferte.json:", error);
    }
}

function incarcaOferte() {
    try {
        const continutFisier = fs.readFileSync(caleFisierOferte, 'utf8');
        const oferteJson = JSON.parse(continutFisier);
        obGlobal.oferte = oferteJson.oferte || [];
        console.log(`Încărcate ${obGlobal.oferte.length} oferte din fișier`);
    } catch (e) {
        console.warn("Nu s-au putut încărca ofertele existente. Se va începe cu listă goală.");
        obGlobal.oferte = [];
    }
}

function initializareOferte() {
    const directorJson = path.dirname(caleFisierOferte);
    if (!fs.existsSync(directorJson)) {
        fs.mkdirSync(directorJson, { recursive: true });
    }

    incarcaCategorii();
    
    incarcaOferte();
    
    setTimeout(() => {
        if (!obGlobal.oferte || obGlobal.oferte.length === 0) {
            console.log("Nu există oferte active. Se generează prima ofertă...");
            genereazaOferta();
        }
    }, 2000);
    
    setInterval(() => {
        console.log(`\n[${new Date().toLocaleString('ro-RO')}] Generare automată ofertă...`);
        genereazaOferta();
    }, T * 60000);
    
    console.log(`Sistem de oferte inițializat. Interval generare: ${T} minute, Păstrare oferte: ${T2} minute`);
}

client.connect().then(() => {
    console.log("Conectat la baza de date");
    initializareOferte();
}).catch(err => {
    console.error("Eroare conectare baza de date:", err);
});

function formatareText(text) {
    return text.replace(/_/g, ' ')
        .replace(/\b\w/g, l => l.toUpperCase())
        .replace(/\bPc\b/g, 'PC');
}

app.locals.formatareText = formatareText;

app.use(function (req, res, next) {
    const queryCategorii = "SELECT unnest(enum_range(NULL::categoria_principala)) AS categorie";
    client.query(queryCategorii, function (err, rezCategorii) {
        if (err) {
            console.log("Eroare middleware categorii:", err);
            res.locals.categoriiPrincipale = [];
            res.locals.subcategorii = [];
            res.locals.mapareSubcategorii = {};
            res.locals.oferte = [];
            return next();
        }

        res.locals.categoriiPrincipale = rezCategorii.rows.map(row => ({
            categ: row.categorie
        }));

        res.locals.oferte = obGlobal.oferte || [];

        const querySubcategorii = "SELECT unnest(enum_range(NULL::subcategorie_produs)) AS subcategorie";
        client.query(querySubcategorii, function (err, rezSubcat) {
            if (err) {
                console.log("Eroare subcategorii:", err);
                res.locals.subcategorii = [];
            } else {
                res.locals.subcategorii = rezSubcat.rows.map(row => row.subcategorie);
            }

            res.locals.mapareSubcategorii = {
                'sisteme_complete': ['pc_gaming', 'pc_office'],
                'componente_hardware': ['procesoare', 'placi_video', 'placi_baza', 'memorii_ram', 'stocare', 'surse_alimentare', 'carcase', 'coolere'],
                'periferice_gaming': ['tastaturi', 'mouse_gaming', 'monitoare', 'casti_audio', 'mousepad'],
                'software_licente': ['sisteme_operare', 'aplicatii_software']
            };

            next();
        });
    });
});

vect_foldere = ["temp", "backup", "temp1"]
for (let folder of vect_foldere) {
    let caleFolder = path.join(__dirname, folder)
    if (!fs.existsSync(caleFolder)) {
        fs.mkdirSync(caleFolder);
    }
}

function compileazaScss(caleScss, caleCss) {
    console.log("cale:", caleCss);
    if (!caleCss) {
        let numeFisExt = path.basename(caleScss); //folder1/folder2/ceva.txt -> "ceva.txt"
        let numeFis = numeFisExt.split(".")[0] /// "a.scss"  -> ["a","scss"]
        caleCss = numeFis + ".css";
    }

    if (!path.isAbsolute(caleScss))
        caleScss = path.join(obGlobal.folderScss, caleScss)
    if (!path.isAbsolute(caleCss))
        caleCss = path.join(obGlobal.folderCss, caleCss)


    let caleBackup = path.join(obGlobal.folderBackup, "resurse/css");
    if (!fs.existsSync(caleBackup)) {
        fs.mkdirSync(caleBackup, {
            recursive: true
        }) //creeaza si directorul parinte daca nu exista
    }

    // la acest punct avem cai absolute in caleScss si  caleCss
    //bonus timestamp
    let numeFisCss = path.basename(caleCss);
    let numeFisFaraExt = numeFisCss.split(".")[0];
    let extensie = numeFisCss.split(".")[1] || "css";
    let timestamp = Date.now();
    let numeFisBackup = `${numeFisFaraExt}_${timestamp}.${extensie}`;

    if (fs.existsSync(caleCss)) {
        fs.copyFileSync(caleCss, path.join(obGlobal.folderBackup, "resurse/css", numeFisBackup));
    }
    rez = sass.compile(caleScss, {
        "sourceMap": true
    });
    fs.writeFileSync(caleCss, rez.css)
}

function compileazaSassGalerieAnimata(numImagini) {

    const sassTemplatePath = path.join(obGlobal.folderScss, 'galerie_animata.scss');
    const sassTemplate = fs.readFileSync(sassTemplatePath, 'utf8');

    const sassContent = sassTemplate.replace('$numar-imagini: 12;', `$numar-imagini: ${numImagini};`);

    const tempSassPath = path.join(obGlobal.folderScss, 'galerie_animata-temp.scss');
    fs.writeFileSync(tempSassPath, sassContent);

    const cssDest = path.join(obGlobal.folderCss, 'galerie_animata.css');
    compileazaScss(tempSassPath, cssDest);

    try {
        fs.unlinkSync(tempSassPath); //stergere fisier temporar
    } catch (err) {
        console.error("Error deleting temporary SASS file:", err);
    }
}

app.get("/galerie", function (req, res) {
    let numImagini = Math.floor(Math.random() * 5) * 3 + 3;
    if (numImagini > 15) numImagini = 15;

    compileazaSassGalerieAnimata(numImagini);

    const offsetImagini = Math.floor(Math.random() * (obGlobal.obimagini.imagini.length - numImagini)); //pozitie random din vect de img
    const imaginiSelectate = obGlobal.obimagini.imagini.slice(offsetImagini, offsetImagini + numImagini); //subset de img consecutive

    res.render("pagini/galerie", { // randeaza pagina din pagini/
        ip: req.ip, //context din django
        imagini: obGlobal.obimagini.imagini,
        imaginiAnimate: imaginiSelectate,
        numarImaginiAnimate: numImagini
    });
});

vFisiere = fs.readdirSync(obGlobal.folderScss);
for (let numeFis of vFisiere) {
    if (path.extname(numeFis) == ".scss") {
        compileazaScss(numeFis);
    }
}


fs.watch(obGlobal.folderScss, function (eveniment, numeFis) {
    console.log(eveniment, numeFis);
    if (eveniment == "change" || eveniment == "rename") {
        let caleCompleta = path.join(obGlobal.folderScss, numeFis);
        if (fs.existsSync(caleCompleta)) {
            compileazaScss(caleCompleta);
        }
    }
})

function initErori() {
    let continut = fs.readFileSync(path.join(__dirname, "resurse/json/erori.json")).toString("utf-8");
    obGlobal.obErori = JSON.parse(continut) //convertesc din json in obiect javascript 

    obGlobal.obErori.eroare_default.imagine = path.join(obGlobal.obErori.cale_baza, obGlobal.obErori.eroare_default.imagine)
    for (let eroare of obGlobal.obErori.info_erori) {
        eroare.imagine = path.join(obGlobal.obErori.cale_baza, eroare.imagine)
    } //definesc caii complete pentru toate imaginile
    console.log(obGlobal.obErori)
}

initErori()

function initimagini() {
    var continut = fs.readFileSync(path.join(__dirname, "resurse/json/galerie.json")).toString("utf-8");

    obGlobal.obimagini = JSON.parse(continut);
    let vimagini = obGlobal.obimagini.imagini;

    let caleAbs = path.join(__dirname, obGlobal.obimagini.cale_galerie);
    let caleAbsMediu = path.join(__dirname, obGlobal.obimagini.cale_galerie, "mediu");
    let caleAbsMic = path.join(__dirname, obGlobal.obimagini.cale_galerie, "mic");

    if (!fs.existsSync(caleAbsMediu)) {
        fs.mkdirSync(caleAbsMediu);
    }

    if (!fs.existsSync(caleAbsMic)) {
        fs.mkdirSync(caleAbsMic);
    }

    for (let imag of vimagini) {
        [numeFis, ext] = imag.fisier.split(".");
        let caleFisAbs = path.join(caleAbs, imag.fisier);
        let caleFisMediuAbs = path.join(caleAbsMediu, numeFis + ".webp"); //compresie mai buna 
        let caleFisMicAbs = path.join(caleAbsMic, numeFis + ".webp");

        sharp(caleFisAbs).resize(400).toFile(caleFisMediuAbs); //resize la 400px
        sharp(caleFisAbs).resize(200).toFile(caleFisMicAbs); //resize la 200px

        imag.fisier_mediu = path.join("/", obGlobal.obimagini.cale_galerie, "mediu", numeFis + ".webp");
        imag.fisier_mic = path.join("/", obGlobal.obimagini.cale_galerie, "mic", numeFis + ".webp");
        imag.fisier = path.join("/", obGlobal.obimagini.cale_galerie, imag.fisier);
    }
}
initimagini();

function afisareEroare(res, identificator, titlu, text, imagine) {
    let eroare = obGlobal.obErori.info_erori.find(function (elem) {
        return elem.identificator == identificator
    });
    if (eroare) {
        if (eroare.status)
            res.status(identificator) //codul de stare http
        var titluCustom = titlu || eroare.titlu; //custom sau default
        var textCustom = text || eroare.text;
        var imagineCustom = imagine || eroare.imagine;


    } else {
        var err = obGlobal.obErori.eroare_default //default daca nu exista
        var titluCustom = titlu || err.titlu;
        var textCustom = text || err.text;
        var imagineCustom = imagine || err.imagine;


    }
    res.render("pagini/eroare", {
        titlu: titluCustom,
        text: textCustom,
        imagine: imagineCustom
    })
}

console.log("Folderul proiectului: ", __dirname); //calea 
console.log("Cale fisier index.js: ", __filename); //calea fisierului curent
console.log("Folderul de lucru: ", process.cwd()); //directorul de lucru curent din care a fost lansat procesul node.js

//fisierele din folderul js /resurse/node_modules devin accesibile prin url-uri
app.use("/js", express.static(path.join(__dirname, "js"))); //express.static pentru servire eficienta
app.use("/resurse", express.static(path.join(__dirname, "resurse")));
app.use("/node_modules", express.static(path.join(__dirname, "node_modules")));
app.get("/favicon.ico", function (req, res) {
    res.sendFile(path.join(__dirname, "resurse/imagini/favicon/favicon.ico"))
}); //request special pentru favicon

app.get(["/", "/home", "/index"], function (req, res) { //multiple rute pentru aceeasi pagina

    const queryLatestProducts = `
        SELECT * FROM produse 
        ORDER BY data_adaugare DESC
        LIMIT 3
    `;

    client.query(queryLatestProducts, function (err, rezLatestProducts) { //execut query-ul 
        if (err) {
            console.log(err);
            res.render("pagini/index", {
                ip: req.ip,
                imagini: obGlobal.obimagini.imagini,
                produse_noi: []
            });
        } else {
            res.render("pagini/index", {
                ip: req.ip,
                imagini: obGlobal.obimagini.imagini,
                produse_noi: rezLatestProducts.rows
            });
        }
    });
});

app.get("/cos", function (req, res) {
    res.render("pagini/cos");
});

app.get("/wishlist", function (req, res) {
    res.render("pagini/wishlist");
});

app.get("/informatii", function (req, res) {
    res.render("pagini/informatii");
});

app.get("/faq", function (req, res) {
    res.render("pagini/faq");
});

app.use(function (err, req, res, next) {
    console.error(err);
    afisareEroare(res, 404);
});

app.get("/cerere", function (req, res) {
    res.send("<p style = 'color:green;'> Bună ziua! </p>");
});

app.get("/fisier", function (req, res) {
    res.sendfile(path.join(__dirname, "package.json"));
});

app.get("/despre", function (req, res) {
    res.render("pagini/despre", {
        ip: req.ip
    });
});

//middleware in lant
app.get("/abc", function (req, res, next) {
    res.write("Data curenta: ");
    next();
});

app.get("/abc", function (req, res, next) {
    res.write((new Date() + ""));
    res.end();
});

app.get("/produse", function (req, res) {
    let conditieQuery = "";
    let paramQuery = [];

    if (req.query.categorie) {
        conditieQuery = " WHERE categorie = $1";
        paramQuery.push(req.query.categorie);
    }

    if (req.query.subcategorie) {
        if (conditieQuery) {
            conditieQuery += " AND subcategorie = $" + (paramQuery.length + 1);
        } else {
            conditieQuery = " WHERE subcategorie = $1";
        }
        paramQuery.push(req.query.subcategorie);
    }

    const queryMinMaxPret = "SELECT MIN(pret) as pret_min, MAX(pret) as pret_max FROM produse";
    client.query(queryMinMaxPret, function (err, rezMinMax) {
        if (err) {
            console.log("Eroare query min/max:", err);
            res.locals.pretMin = 0;
            res.locals.pretMax = 10000;
        } else {
            res.locals.pretMin = rezMinMax.rows[0].pret_min || 0;
            res.locals.pretMax = rezMinMax.rows[0].pret_max || 10000;
        }

        const queryProduseIeftineSubcategorii = `
            SELECT DISTINCT ON (subcategorie) 
                id, subcategorie, pret, nume
            FROM produse 
            WHERE pret IS NOT NULL AND subcategorie IS NOT NULL
            ORDER BY subcategorie, pret ASC, id ASC
        `;

        client.query(queryProduseIeftineSubcategorii, function (err, rezProduseIeftineSubcat) {
            if (err) {
                console.error("Eroare la query produse ieftine pe subcategorii:", err);
                res.locals.produseIeftineSet = new Set();
            } else {
                const produseIeftineSet = new Set();
                for (let prod of rezProduseIeftineSubcat.rows) {
                    produseIeftineSet.add(prod.id);
                }
                res.locals.produseIeftineSet = produseIeftineSet;
                
                console.log("Produse cele mai ieftine din fiecare subcategorie:", 
                    rezProduseIeftineSubcat.rows.map(p => `${p.nume} (${p.subcategorie}) - ${p.pret} RON`));
            }

            const queryOptiuni = "SELECT unnest(enum_range(NULL::categoria_principala)) AS categ";

            client.query(queryOptiuni, function (err, rezOptiuni) {
                if (err) {
                    console.log("Eroare categorii:", err);
                    res.locals.optiuni = [];
                } else {
                    res.locals.optiuni = rezOptiuni.rows.map(row => ({
                        categ: row.categorie
                    }));
                }

                const queryCaracteristici = `
                    SELECT DISTINCT unnest(string_to_array(
                        CASE 
                            WHEN specificatii_tehnice ~ '^{.*}$' 
                            THEN translate(specificatii_tehnice, '{}\"', '')
                            ELSE specificatii_tehnice 
                        END, ','
                    )) as caracteristica 
                    FROM produse 
                    WHERE specificatii_tehnice IS NOT NULL 
                    ORDER BY caracteristica`;

                client.query(queryCaracteristici, function (err, rezCaract) {
                    if (err) {
                        res.locals.caracteristiciDisponibile = [];
                    } else {
                        res.locals.caracteristiciDisponibile = rezCaract.rows.map(row =>
                            row.caracteristica.trim().toLowerCase()
                        ).filter(c => c.length > 0);
                    }

                    const queryBranduri = "SELECT DISTINCT brand FROM produse WHERE brand IS NOT NULL ORDER BY brand";

                    client.query(queryBranduri, function (err, rezBranduri) {
                        if (err) {
                            res.locals.branduri = [];
                            res.locals.branduriDatalist = [];
                        } else {
                            res.locals.branduri = rezBranduri.rows;
                            res.locals.branduriDatalist = res.locals.branduri;
                        }

                        const querySubcategorii = "SELECT DISTINCT subcategorie FROM produse WHERE subcategorie IS NOT NULL ORDER BY subcategorie";

                        client.query(querySubcategorii, function (err, rezSubcat) {
                            if (err) {
                                res.locals.subcategoriiDisponibile = [];
                            } else {
                                res.locals.subcategoriiDisponibile = rezSubcat.rows.map(row => row.subcategorie);
                            }

                            let queryProduse = `SELECT * FROM produse ${conditieQuery} ORDER BY id`;

                            client.query(queryProduse, paramQuery, function (err, rez) {
                                if (err) {
                                    console.log("Eroare la query produse:", err);
                                    afisareEroare(res, 500, "Eroare bază de date", "Nu s-au putut încărca produsele.");
                                } else {
                                    res.render("pagini/produse", {
                                        produse: rez.rows,
                                        optiuni: rezOptiuni.rows,
                                        branduri: rezBranduri.rows.map(row => ({
                                            brand: row.brand
                                        }))
                                    });
                                }
                            });
                        });
                    });
                });
            });
        });
    });
});

app.get("/seturi", function(req, res) {
    const querySeturi = `
        SELECT 
            s.id, 
            s.nume_set, 
            s.descriere_set, 
            json_agg(json_build_object(
                'id', p.id,
                'nume', p.nume,
                'imagine', p.imagine,
                'pret', p.pret,
                'brand', p.brand,
                'subcategorie', p.subcategorie
            )) AS produse
        FROM seturi s
        JOIN asociere_set a ON s.id = a.id_set
        JOIN produse p ON a.id_produs = p.id
        GROUP BY s.id, s.nume_set, s.descriere_set
        ORDER BY s.id`;
    
    client.query(querySeturi, function(err, rezultat) {
        if (err) {
            console.error("Eroare la query seturi: ", err);
            afisareEroare(res, 500, "Eroare bază de date", "Nu s-au putut încărca seturile.");
        } else {
            console.log("Seturi încărcate:", rezultat.rows);
            res.render("pagini/seturi", {
                seturi: rezultat.rows,
                ip: req.ip
            });
        }
    });
});


app.get("/produs/:id", function(req, res) {
    let idProdus = parseInt(req.params.id);

    const queryProdus = "SELECT * FROM produse WHERE id = $1";
    
    client.query(queryProdus, [idProdus], function(err, rez) {
        if (err) {
            console.error("Eroare la încărcarea produsului:", err);
            afisareEroare(res, 500, "Eroare bază de date", "Nu s-a putut încărca produsul.");
            return;
        }
        
        if (rez.rows.length === 0) {
            afisareEroare(res, 404, "Produs negăsit", "Produsul solicitat nu există.");
            return;
        }
        
        const querySeturiCuProdus = `
            SELECT 
                s.id,
                s.nume_set,
                s.descriere_set,
                json_agg(json_build_object(
                    'id', p.id,
                    'nume', p.nume,
                    'imagine', p.imagine,
                    'pret', p.pret,
                    'brand', p.brand,
                    'subcategorie', p.subcategorie
                )) AS produse
            FROM seturi s
            JOIN asociere_set a1 ON s.id = a1.id_set
            JOIN asociere_set a2 ON s.id = a2.id_set
            JOIN produse p ON a2.id_produs = p.id
            WHERE a1.id_produs = $1
            GROUP BY s.id, s.nume_set, s.descriere_set
            ORDER BY s.id`;
        
        client.query(querySeturiCuProdus, [idProdus], function(errSeturi, rezSeturi) {
            if (errSeturi) {
                console.error("Eroare la încărcarea seturilor:", errSeturi);
                res.render("pagini/produs", {
                    produs: rez.rows[0],
                    seturi_cu_produs: [],
                    ip: req.ip
                });
            } else {
                console.log("Seturi cu produsul", idProdus, ":", rezSeturi.rows);
                res.render("pagini/produs", {
                    produs: rez.rows[0],
                    seturi_cu_produs: rezSeturi.rows,
                    ip: req.ip
                });
            }
        });
    });
});

//new Regex("")
app.get(/^\/resurse\/[a-zA-Z0-9_\/]*$/, function (req, res, next) { //blocarea accesului la directorul resurse (cai care incep cu /resurse/)
    afisareEroare(res, 403); //forbidden
    // /../ inceput-sfarsit expresie
    // ^ .. $ inceput-sfarsit text
    // \/ pentr a fi tratate ca litere
});

app.get("/*.ejs", function (req, res, next) { //blocare fisiere ejs
    afisareEroare(res, 400); //bad request
});

app.get("/*", function (req, res, next) {
    try {
        res.render("pagini" + req.url, function (err, rezultatRandare) {
            if (err) {
                if (err.message.startsWith("Failed to lookup view")) {
                    afisareEroare(res, 404);
                } else {
                    afisareEroare(res);
                }
            } else {
                console.log(rezultatRandare);
                res.send(rezultatRandare)
            }
        });
    } catch (errRandare) { //erori inaintea randarii
        if (errRandare.message.startsWith("Cannot find module")) {
            afisareEroare(res, 404);
        } else {
            afisareEroare(res);
        }
    }
})

app.listen(8080); //serverul "asculta" cereri http
console.log("Serverul a pornit");