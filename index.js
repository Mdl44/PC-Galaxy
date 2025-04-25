const express= require("express"); // server
const path = require("path"); //path-uri de foldere
const fs = require("fs"); // fisiere
const sharp = require("sharp"); //imagini
const sass = require("sass"); // pentru compilare SCSS in CSS
const pg = require("pg"); //baza de date postgresql

//baza de date 
const Client=pg.Client;

client=new Client({
    database:"proiect",
    user:"madalin",
    password:"madalin",
    host:"localhost",
    port:5432
})

client.connect()
client.query("select * from prajituri", function(err, rezultat ){
    console.log(err)    
    console.log(rezultat)
})
client.query("select * from unnest(enum_range(null::categ_prajitura))", function(err, rezultat ){
    console.log(err)    
    console.log(rezultat)
})
//

app= express();

v= [10,27,23,44,15]
nrImpar=v.find(function(elem){return elem%2 == 1})
console.log(nrImpar) 

app.set("view engine", "ejs");

//variabile globale
obGlobal= {
    obErori:null,
    obimagini:null,
    folderScss: path.join(__dirname, "resurse/scss"),
    folderCss: path.join(__dirname,"resurse/css"),
    folderBackup: path.join(__dirname,"backup")
}

//creez fisierele pentru backup/temp
vect_foldere=["temp","backup","temp1"]
for(let folder of vect_foldere){
    let caleFolder= path.join(__dirname,folder)
    if(!fs.existsSync(folder)){
        fs.mkdirSync(folder);
    }
}

function compileazaScss(caleScss, caleCss){
    console.log("cale:",caleCss);
    if(!caleCss){

        let numeFisExt=path.basename(caleScss); //folder1/folder2/ceva.txt -> "ceva.txt"
        let numeFis=numeFisExt.split(".")[0]   /// "a.scss"  -> ["a","scss"]
        caleCss=numeFis+".css";
    }
    
    if (!path.isAbsolute(caleScss))
        caleScss=path.join(obGlobal.folderScss,caleScss )
    if (!path.isAbsolute(caleCss))
        caleCss=path.join(obGlobal.folderCss,caleCss )
    

    let caleBackup=path.join(obGlobal.folderBackup, "resurse/css");
    if (!fs.existsSync(caleBackup)) {
        fs.mkdirSync(caleBackup,{recursive:true})
    }
    
    // la acest punct avem cai absolute in caleScss si  caleCss
    //bonus timestamp
    let numeFisCss=path.basename(caleCss);
    let numeFisFaraExt = numeFisCss.split(".")[0];
    let extensie = numeFisCss.split(".")[1] || "css";
    let timestamp = Date.now();
    let numeFisBackup = `${numeFisFaraExt}_${timestamp}.${extensie}`;
    
    if (fs.existsSync(caleCss)){
        fs.copyFileSync(caleCss, path.join(obGlobal.folderBackup, "resurse/css", numeFisBackup));
    }
    rez=sass.compile(caleScss, {"sourceMap":true});
    fs.writeFileSync(caleCss,rez.css)
    //console.log("Compilare SCSS",rez);
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
      fs.unlinkSync(tempSassPath);
    } catch (err) {
      console.error("Error deleting temporary SASS file:", err);
    }
  }
  
  app.get("/galerie", function(req, res) {
    let numImagini = Math.floor(Math.random() * 5) * 3 + 3;
    if (numImagini > 15) numImagini = 15;
    
    compileazaSassGalerieAnimata(numImagini);
    
    const offsetImagini = Math.floor(Math.random() * (obGlobal.obimagini.imagini.length - numImagini));
    
    const imaginiSelectate = obGlobal.obimagini.imagini.slice(offsetImagini, offsetImagini + numImagini);
    
    res.render("pagini/galerie", {
      ip: req.ip, 
      imagini: obGlobal.obimagini.imagini,
      imaginiAnimate: imaginiSelectate,
      numarImaginiAnimate: numImagini
    });
  });


vFisiere=fs.readdirSync(obGlobal.folderScss);
for( let numeFis of vFisiere ){
    if (path.extname(numeFis)==".scss"){
        compileazaScss(numeFis);
    }
}

//la pornirea serverului
fs.watch(obGlobal.folderScss, function(eveniment, numeFis){
    console.log(eveniment, numeFis);
    if (eveniment=="change" || eveniment=="rename"){
        let caleCompleta=path.join(obGlobal.folderScss, numeFis);
        if (fs.existsSync(caleCompleta)){
            compileazaScss(caleCompleta);
        }
    }
})


function initErori(){
    let continut = fs.readFileSync(path.join(__dirname,"resurse/json/erori.json")).toString("utf-8");
    
    obGlobal.obErori=JSON.parse(continut)
    
    obGlobal.obErori.eroare_default.imagine=path.join(obGlobal.obErori.cale_baza, obGlobal.obErori.eroare_default.imagine)
    for (let eroare of obGlobal.obErori.info_erori){
        eroare.imagine=path.join(obGlobal.obErori.cale_baza, eroare.imagine)
    }
    console.log(obGlobal.obErori)

}

initErori()

function initimagini(){
    var continut= fs.readFileSync(path.join(__dirname,"resurse/json/galerie.json")).toString("utf-8");

    obGlobal.obimagini=JSON.parse(continut);
    let vimagini=obGlobal.obimagini.imagini;

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
        let caleFisMediuAbs = path.join(caleAbsMediu, numeFis + ".webp");
        let caleFisMicAbs = path.join(caleAbsMic, numeFis + ".webp");
        
        sharp(caleFisAbs).resize(400).toFile(caleFisMediuAbs);
        sharp(caleFisAbs).resize(200).toFile(caleFisMicAbs);
        
        imag.fisier_mediu = path.join("/", obGlobal.obimagini.cale_galerie, "mediu", numeFis + ".webp");
        imag.fisier_mic = path.join("/", obGlobal.obimagini.cale_galerie, "mic", numeFis + ".webp");
        imag.fisier = path.join("/", obGlobal.obimagini.cale_galerie, imag.fisier);
    }
}
initimagini();

function afisareEroare(res, identificator, titlu, text, imagine){
    let eroare= obGlobal.obErori.info_erori.find(function(elem){ 
                        return elem.identificator==identificator
                    });
    if(eroare){
        if(eroare.status)
            res.status(identificator)
        var titluCustom=titlu || eroare.titlu;
        var textCustom=text || eroare.text;
        var imagineCustom=imagine || eroare.imagine;


    }
    else{
        var err=obGlobal.obErori.eroare_default
        var titluCustom=titlu || err.titlu;
        var textCustom=text || err.text;
        var imagineCustom=imagine || err.imagine;


    }
    res.render("pagini/eroare", { //transmit obiectul locals
        titlu: titluCustom,
        text: textCustom,
        imagine: imagineCustom
})

}

console.log("Folderul proiectului: ", __dirname);
console.log("Cale fisier index.js: ", __filename);
console.log("Folderul de lucru: ", process.cwd());

app.use("/resurse",express.static(path.join(__dirname,"resurse")));
app.use("/node_modules",express.static(path.join(__dirname,"node_modules")));
app.get("/favicon.ico", function(req,res){
    res.sendFile(path.join(__dirname, "resurse/imagini/favicon/favicon.ico"))
});

app.get(["/", "/home", "/index"], function(req, res){
    res.render("pagini/index",{ip:req.ip, imagini:obGlobal.obimagini.imagini});
});

app.get("/cos", function(req, res){
    res.render("pagini/cos");
});

app.get("/wishlist", function(req, res){
    res.render("pagini/wishlist");
});

app.get("/informatii", function(req, res){
    res.render("pagini/informatii");
});

app.get("/faq", function(req, res){
    res.render("pagini/faq");
});

app.use(function(err, req, res, next) {
    console.error(err);
    afisareEroare(res, 404);
  });

app.get("/cerere", function(req, res){
    res.send("<p style = 'color:green;'> Bună ziua! </p>");
});

app.get("/fisier", function(req, res){
    res.sendfile(path.join(__dirname, "package.json"));
});

app.get("/despre", function(req, res){
    res.render("pagini/despre", {ip: req.ip});
});

app.get("/abc", function(req, res, next){
    res.write("Data curenta: ");
    next();
});

app.get("/abc", function(req, res, next){
    res.write((new Date() + ""));
    res.end();
});

app.get("/produse", function(req, res){
    console.log(req.query)
    var conditieQuery="";


    queryOptiuni="select * from unnest(enum_range(null::categ_prajitura))"
    client.query(queryOptiuni, function(err, rezOptiuni){
        console.log(rezOptiuni)


        queryProduse="select * from prajituri"
        client.query(queryProduse, function(err, rez){
            if (err){
                console.log(err);
                afisareEroare(res, 2);
            }
            else{
                res.render("pagini/produse", {produse: rez.rows, optiuni:rezOptiuni.rows})
            }
        })
    });
})

//new Regex("")
app.get(/^\/resurse\/[a-zA-Z0-9_\/]*$/,function(req,res,next){
    afisareEroare(res,403);
});

app.get("/*.ejs",function(req,res,next){
    afisareEroare(res,400);
});


app.get("/*", function(req,res,next){
    try {
    res.render("pagini" + req.url, function (err,rezultatRandare){
        if(err){
            if(err.message.startsWith("Failed to lookup view")){
                afisareEroare(res,404);
            }
            else {
                afisareEroare(res);
            }
        }
        else {
            console.log(rezultatRandare);
            res.send(rezultatRandare)
        }
    });
    }
    catch(errRandare){
        if(errRandare.message.startsWith("Cannot find module")){
            afisareEroare(res,404);
        }
        else {
            afisareEroare(res);
        }
    }
})


app.listen(8080);
console.log("Serverul a pornit");


