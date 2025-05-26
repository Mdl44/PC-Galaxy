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

client.connect()

app = express(); // obiect server express

app.set("view engine", "ejs"); //ejs ca template 

//variabile globale
obGlobal = {
    obErori: null,
    obimagini: null,
    folderScss: path.join(__dirname, "resurse/scss"),
    folderCss: path.join(__dirname, "resurse/css"),
    folderBackup: path.join(__dirname, "backup"),
    optiuniMeniu: null
}

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
            return next();
        }

        res.locals.categoriiPrincipale = rezCategorii.rows.map(row => ({
            categ: row.categorie
        }));


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


app.get("/produs/:id", (req, res) => {
    const idProdus = req.params.id;

    const queryProdus = `SELECT * FROM produse WHERE id = $1`;

    client.query(queryProdus, [idProdus], (err, rezProdus) => {
        if (err || rezProdus.rows.length === 0) {
            afisareEroare(res, 404, "Produs inexistent", "Produsul căutat nu există.");
            return;
        }

        const produs = rezProdus.rows[0];

        res.render("pagini/produs", {
            produs: produs
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