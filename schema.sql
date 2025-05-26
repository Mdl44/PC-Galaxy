DROP TABLE IF EXISTS produse CASCADE;
DROP TYPE IF EXISTS categoria_principala CASCADE;
DROP TYPE IF EXISTS subcategorie_produs CASCADE;
DROP TYPE IF EXISTS stare_stoc CASCADE;
DROP TYPE IF EXISTS tip_conectivitate CASCADE;

CREATE TYPE categoria_principala AS ENUM(
    'sisteme_complete',
    'componente_hardware',
    'periferice_gaming',
    'software_licente'
);

CREATE TYPE subcategorie_produs AS ENUM (
    'pc_gaming',
    'pc_office',
    'procesoare',
    'placi_video',
    'placi_baza',
    'memorii_ram',
    'stocare',
    'surse_alimentare',
    'carcase',
    'coolere',
    'tastaturi',
    'mouse_gaming',
    'monitoare',
    'casti_audio',
    'mousepad',
    'sisteme_operare',
    'aplicatii_software'
);

CREATE TYPE stare_stoc AS ENUM('În stoc', 'Stoc limitat', 'La comandă', 'Indisponibil');

CREATE TYPE tip_conectivitate AS ENUM('USB', 'Wireless', 'Bluetooth', 'Combo', 'Jack 3.5mm', 'USB-C');

CREATE TABLE produse (
    id SERIAL PRIMARY KEY,
    nume VARCHAR(150) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    descriere TEXT,
    imagine VARCHAR(300),
    categorie categoria_principala NOT NULL,
    subcategorie subcategorie_produs NOT NULL,
    pret NUMERIC(8,2) NOT NULL CHECK (pret >= 0),
    performanta_score INTEGER CHECK (performanta_score >= 0 AND performanta_score <= 100),
    data_adaugare TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    culoare VARCHAR(50),
    specificatii_tehnice VARCHAR[],
    gaming_ready BOOLEAN DEFAULT FALSE,
    wireless_support BOOLEAN DEFAULT FALSE,
    stoc INTEGER DEFAULT 0,
    stoc_status stare_stoc DEFAULT 'Indisponibil',
    greutate_grame INTEGER,
    consum_watt INTEGER,
    garantie_luni INTEGER DEFAULT 24
);

CREATE INDEX idx_produse_categorie ON produse(categorie);
CREATE INDEX idx_produse_subcategorie ON produse(subcategorie);
CREATE INDEX idx_produse_pret ON produse(pret);
CREATE INDEX idx_produse_gaming ON produse(gaming_ready);
CREATE INDEX idx_produse_stoc ON produse(stoc_status);

-- PC-uri Gaming
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie, 
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'PC Galaxy Gaming Start', 'PC Galaxy', 
    'Sistem entry-level pentru jocuri la setări medii, ideal pentru buget redus', 
    '/resurse/imagini/produse/pc/gaming_start.jpg', 3499.99, 'Alb',
    'sisteme_complete', 'pc_gaming',
    65, TRUE, TRUE,
    10, 'În stoc', 550,
    ARRAY[
        'Procesor: Intel Core i3-12100F, 4 nuclee, 3.3GHz, 12MB',
        'Placă de bază: MSI PRO H610M-G',
        'Placă video: GeForce RTX 4060 8GB GDDR6',
        'Memorie RAM: 16GB DDR4 3200MHz',
        'Stocare: SSD 500GB NVMe + HDD 1TB 7200RPM',
        'Sistem operare: Windows 11 Home',
        'Carcasă: Segotep Mini Knight',
        'Sursă: AQIRYS Performance 550W',
        'Răcire: Cooler CPU stock Intel',
        'Conectivitate: Gigabit LAN, Wi-Fi 5'
    ]
),
(
    'PC Galaxy Gaming Plus', 'PC Galaxy',
    'Sistem mid-range pentru jocuri la setări înalte în Full HD',
    '/resurse/imagini/produse/pc/gaming_plus.jpg', 4799.99, 'Negru/RGB',
    'sisteme_complete', 'pc_gaming',
    75, TRUE, TRUE,
    10, 'În stoc', 650,
    ARRAY[
        'Procesor: AMD Ryzen 5 5600X, 6 nuclee, 3.7GHz, 32MB',
        'Placă de bază: ASUS PRIME B550M-K',
        'Placă video: GeForce RTX 4060 12GB GDDR6',
        'Memorie RAM: 16GB DDR4 3600MHz dual channel',
        'Stocare: SSD 1TB NVMe PCIe Gen4',
        'Sistem operare: Windows 11 Home',
        'Carcasă: Corsair 4000D Airflow',
        'Sursă: AQIRYS Pulsar 650W 80+ Bronze',
        'Răcire: ID-Cooling SE-224-XT',
        'Conectivitate: Gigabit LAN, Wi-Fi 6'
    ]
),
(
    'PC Galaxy Gaming Pro', 'PC Galaxy',
    'Sistem performant pentru gaming 1440p fluid și productivitate',
    '/resurse/imagini/produse/pc/gaming_pro.jpg', 6999.99, 'Negru/RGB',
    'sisteme_complete', 'pc_gaming',
    85, TRUE, TRUE,
    10, 'În stoc', 750,
    ARRAY[
        'Procesor: Intel Core i5-13600KF, 14 nuclee, 3.5GHz, 24MB',
        'Placă de bază: MSI PRO Z690-A DDR4',
        'Placă video: GeForce RTX 4060 Ti 16GB GDDR6',
        'Memorie RAM: 32GB DDR4 3600MHz dual channel',
        'Stocare: SSD 1TB NVMe PCIe Gen4 + HDD 2TB 7200RPM',
        'Sistem operare: Windows 11 Home',
        'Carcasă: NZXT H5 Flow',
        'Sursă: Corsair RM750e 80+ Gold',
        'Răcire: be quiet! Pure Rock 2',
        'Conectivitate: Gigabit LAN, Wi-Fi 6, Bluetooth 5.1'
    ]
),
(
    'PC Galaxy Gaming Elite', 'PC Galaxy',
    'Sistem high-end pentru gaming 4K și streaming profesional',
    '/resurse/imagini/produse/pc/gaming_elite.jpg', 9999.99, 'Negru/RGB',
    'sisteme_complete', 'pc_gaming',
    92, TRUE, TRUE,
    10, 'În stoc', 850,
    ARRAY[
        'Procesor: AMD Ryzen 7 7700X, 8 nuclee, 4.5GHz, 32MB',
        'Placă de bază: ASUS TUF GAMING X670E-PLUS',
        'Placă video: GeForce RTX 4070 12GB GDDR6X',
        'Memorie RAM: 32GB DDR5 5200MHz dual channel',
        'Stocare: SSD 2TB NVMe PCIe Gen4 + HDD 4TB 7200RPM',
        'Sistem operare: Windows 11 Pro',
        'Carcasă: Lian Li PC-O11 Dynamic EVO',
        'Sursă: Seasonic Focus GX-850 80+ Gold',
        'Răcire: NZXT Kraken X63 RGB 280mm',
        'Conectivitate: Gigabit LAN, Wi-Fi 6E, Bluetooth 5.2'
    ]
),
(
    'PC Galaxy Gaming Ultimate', 'PC Galaxy',
    'Sistem de top fără compromisuri pentru gaming și productivitate extremă',
    '/resurse/imagini/produse/pc/gaming_ultimate.jpg', 15999.99, 'Negru/RGB',
    'sisteme_complete', 'pc_gaming',
    100, TRUE, TRUE,
    10, 'În stoc', 1000,
    ARRAY[
        'Procesor: Intel Core i9-13900K, 24 nuclee, 3.0GHz, 36MB',
        'Placă de bază: MSI MEG Z690 ACE',
        'Placă video: GeForce RTX 4090 24GB GDDR6X',
        'Memorie RAM: 64GB DDR5 6000MHz dual channel',
        'Stocare: SSD 2TB NVMe PCIe Gen4 + SSD 4TB NVMe PCIe Gen4',
        'Sistem operare: Windows 11 Pro',
        'Carcasă: Phanteks Enthoo 719',
        'Sursă: Seasonic Prime TX-1000 80+ Titanium',
        'Răcire: NZXT Kraken Z73 RGB 360mm',
        'Conectivitate: Gigabit LAN, Wi-Fi 6E, Bluetooth 5.2'
    ]
);

-- PC-uri Office
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'PC Galaxy Office Basic', 'PC Galaxy',
    'Sistem office pentru sarcini de bază: navigare, documente, e-mail',
    '/resurse/imagini/produse/pc/office_basic.jpg', 1899.99, 'Negru',
    'sisteme_complete', 'pc_office',
    35, FALSE, TRUE,
    10, 'În stoc', 400,
    ARRAY[
        'Procesor: Intel Core i3-12100, 4 nuclee, 3.3GHz, 12MB',
        'Placă de bază: ASUS PRIME H610M-K',
        'Placă video: Intel UHD Graphics 730',
        'Memorie RAM: 8GB DDR4 3200MHz',
        'Stocare: SSD 256GB NVMe',
        'Sistem operare: Windows 11 Home',
        'Carcasă: Fractal Design Core 1000',
        'Sursă: Be Quiet! System Power 9 400W',
        'Răcire: Cooler CPU stock Intel',
        'Conectivitate: Gigabit LAN, Wi-Fi 5'
    ]
),
(
    'PC Galaxy Office Standard', 'PC Galaxy',
    'Sistem office versatil pentru multitasking și aplicații de productivitate',
    '/resurse/imagini/produse/pc/office_standard.jpg', 2899.99, 'Negru',
    'sisteme_complete', 'pc_office',
    55, FALSE, TRUE,
    10, 'În stoc', 550,
    ARRAY[
        'Procesor: Intel Core i5-12400, 6 nuclee, 2.5GHz, 18MB',
        'Placă de bază: ASUS PRIME B660M-K',
        'Placă video: Intel UHD Graphics 730',
        'Memorie RAM: 16GB DDR4 3200MHz dual channel',
        'Stocare: SSD 512GB NVMe + HDD 1TB 7200RPM',
        'Sistem operare: Windows 11 Home',
        'Carcasă: Corsair 275R Airflow',
        'Sursă: AQIRYS Performance 550W',
        'Răcire: Cooler CPU stock Intel',
        'Conectivitate: Gigabit LAN, Wi-Fi 6, Bluetooth 5.1'
    ]
),
(
    'PC Galaxy Office Pro', 'PC Galaxy',
    'Sistem office performant pentru profesionişti, ideal pentru aplicaţii complexe',
    '/resurse/imagini/produse/pc/office_pro.jpg', 4499.99, 'Negru',
    'sisteme_complete', 'pc_office',
    70, FALSE, TRUE,
    10, 'În stoc', 650,
    ARRAY[
        'Procesor: AMD Ryzen 7 5700G, 8 nuclee, 3.8GHz, 16MB',
        'Placă de bază: MSI MPG B550 GAMING PLUS',
        'Placă video: AMD Radeon Graphics',
        'Memorie RAM: 32GB DDR4 3600MHz dual channel',
        'Stocare: SSD 1TB NVMe PCIe Gen4 + HDD 2TB 7200RPM',
        'Sistem operare: Windows 11 Pro',
        'Carcasă: Fractal Design Meshify C',
        'Sursă: Corsair RM650 80+ Gold',
        'Răcire: be quiet! Pure Rock 2',
        'Conectivitate: Gigabit LAN, Wi-Fi 6, Bluetooth 5.1'
    ]
);

-- Procesoare Intel
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'Core i3-14100F', 'Intel', 
    'Procesor de buget din generația a 14-a, ideal pentru utilizare zilnică și gaming entry-level. Oferă un raport preț/performanță excelent.',
    '/resurse/imagini/produse/procesoare/i3_14100f.jpg', 599.99, 'N/A',
    'componente_hardware', 'procesoare',
    45, TRUE, FALSE,
    25, 'În stoc', 65,
    ARRAY[
        'Socket: LGA1700',
        'Arhitectura: Raptor Lake Refresh',
        'Nuclee: 4 (4P+0E)',
        'Thread-uri: 8',
        'Frecvența de bază: 3.5 GHz',
        'Frecvența Turbo: 4.7 GHz',
        'Cache L3: 12MB',
        'TDP: 58W',
        'Grafica integrată: Nu',
        'Suport memorie: DDR4-3200, DDR5-4800'
    ]
),
(
    'Core i5-13400F', 'Intel',
    'Procesor mid-range versatil cu 10 nuclee (6P+4E) ideal pentru multitasking și gaming la rezoluții medii.',
    '/resurse/imagini/produse/procesoare/i5_13400f.jpg', 899.99, 'N/A',
    'componente_hardware', 'procesoare',
    65, TRUE, FALSE,
    25, 'În stoc', 65,
    ARRAY[
        'Socket: LGA1700',
        'Arhitectura: Raptor Lake',
        'Nuclee: 10 (6P+4E)',
        'Thread-uri: 16',
        'Frecvența de bază: 2.5 GHz',
        'Frecvența Turbo: 4.6 GHz',
        'Cache L3: 20MB',
        'TDP: 65W',
        'Grafica integrată: Nu',
        'Suport memorie: DDR4-3200, DDR5-4800'
    ]
),
(
    'Core i5-14600K', 'Intel',
    'Procesor performant din generația a 14-a cu 14 nuclee (6P+8E) și suport pentru overclocking. Excelent pentru gaming și creație de conținut.',
    '/resurse/imagini/produse/procesoare/i5_14600k.jpg', 1499.99, 'N/A',
    'componente_hardware', 'procesoare',
    78, TRUE, FALSE,
    25, 'În stoc', 125,
    ARRAY[
        'Socket: LGA1700',
        'Arhitectura: Raptor Lake Refresh',
        'Nuclee: 14 (6P+8E)',
        'Thread-uri: 20',
        'Frecvența de bază: 3.5 GHz',
        'Frecvența Turbo: 5.3 GHz',
        'Cache L3: 24MB',
        'TDP: 125W',
        'Grafica integrată: Intel UHD Graphics 770',
        'Suport memorie: DDR4-3200, DDR5-5600'
    ]
),
(
    'Core i7-14700K', 'Intel',
    'Procesor high-end cu 20 nuclee (8P+12E) din generația Raptor Lake Refresh, ideal pentru gaming și producție video.',
    '/resurse/imagini/produse/procesoare/i7_14700k.jpg', 2099.99, 'N/A',
    'componente_hardware', 'procesoare',
    88, TRUE, FALSE,
    25, 'În stoc', 125,
    ARRAY[
        'Socket: LGA1700',
        'Arhitectura: Raptor Lake Refresh',
        'Nuclee: 20 (8P+12E)',
        'Thread-uri: 28',
        'Frecvența de bază: 3.4 GHz',
        'Frecvența Turbo: 5.6 GHz',
        'Cache L3: 33MB',
        'TDP: 125W',
        'Grafica integrată: Intel UHD Graphics 770',
        'Suport memorie: DDR4-3200, DDR5-5600'
    ]
),
(
    'Core i9-14900K', 'Intel',
    'Flagship Intel din generația a 14-a cu 24 nuclee (8P+16E) pentru performanțe extreme în aplicații profesionale și gaming.',
    '/resurse/imagini/produse/procesoare/i9_14900k.jpg', 2799.99, 'N/A',
    'componente_hardware', 'procesoare',
    95, TRUE, FALSE,
    25, 'În stoc', 150,
    ARRAY[
        'Socket: LGA1700',
        'Arhitectura: Raptor Lake Refresh',
        'Nuclee: 24 (8P+16E)',
        'Thread-uri: 32',
        'Frecvența de bază: 3.2 GHz',
        'Frecvența Turbo: 6.0 GHz',
        'Cache L3: 36MB',
        'TDP: 125W (PL1), 253W (PL2)',
        'Grafica integrată: Intel UHD Graphics 770',
        'Suport memorie: DDR4-3200, DDR5-5600'
    ]
);

-- Procesoare AMD
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'Ryzen 5 7600', 'AMD',
    'Procesor de buget cu 6 nuclee și 12 fire de execuție pe arhitectura Zen 4, cu un TDP eficient și performanțe solide.',
    '/resurse/imagini/produse/procesoare/ryzen5_7600.jpg', 849.99, 'N/A',
    'componente_hardware', 'procesoare',
    70, TRUE, FALSE,
    25, 'În stoc', 65,
    ARRAY[
        'Socket: AM5',
        'Arhitectura: Zen 4',
        'Nuclee: 6',
        'Thread-uri: 12',
        'Frecvența de bază: 3.8 GHz',
        'Frecvența Boost: 5.1 GHz',
        'Cache L3: 32MB',
        'TDP: 65W',
        'Grafica integrată: Nu',
        'Suport memorie: DDR5-5200'
    ]
),
(
    'Ryzen 5 7600X', 'AMD',
    'Procesor mid-range cu 6 nuclee și frecvență ridicată, ideal pentru gaming și multitasking la un preț accesibil.',
    '/resurse/imagini/produse/procesoare/ryzen5_7600x.jpg', 1099.99, 'N/A',
    'componente_hardware', 'procesoare',
    75, TRUE, FALSE,
    25, 'În stoc', 105,
    ARRAY[
        'Socket: AM5',
        'Arhitectura: Zen 4',
        'Nuclee: 6',
        'Thread-uri: 12',
        'Frecvența de bază: 4.7 GHz',
        'Frecvența Boost: 5.3 GHz',
        'Cache L3: 32MB',
        'TDP: 105W',
        'Grafica integrată: Nu',
        'Suport memorie: DDR5-5200'
    ]
),
(
    'Ryzen 7 7700X', 'AMD',
    'Procesor performant cu 8 nuclee și 16 fire de execuție pentru gaming și creație de conținut fără compromisuri.',
    '/resurse/imagini/produse/procesoare/ryzen7_7700x.jpg', 1699.99, 'N/A',
    'componente_hardware', 'procesoare',
    82, TRUE, FALSE,
    25, 'În stoc', 105,
    ARRAY[
        'Socket: AM5',
        'Arhitectura: Zen 4',
        'Nuclee: 8',
        'Thread-uri: 16',
        'Frecvența de bază: 4.5 GHz',
        'Frecvența Boost: 5.4 GHz',
        'Cache L3: 32MB',
        'TDP: 105W',
        'Grafica integrată: Nu',
        'Suport memorie: DDR5-5200'
    ]
),
(
    'Ryzen 7 8700X', 'AMD',
    'Procesor high-end din noua generație Zen 5 cu 8 nuclee și 16 fire de execuție, IPC îmbunătățit și NPU integrat.',
    '/resurse/imagini/produse/procesoare/ryzen7_8700x.jpg', 2299.99, 'N/A',
    'componente_hardware', 'procesoare',
    85, TRUE, FALSE,
    25, 'În stoc', 105,
    ARRAY[
        'Socket: AM5',
        'Arhitectura: Zen 5',
        'Nuclee: 8',
        'Thread-uri: 16',
        'Frecvența de bază: 4.2 GHz',
        'Frecvența Boost: 5.5 GHz',
        'Cache L3: 40MB',
        'TDP: 105W',
        'Grafica integrată: RDNA 2',
        'NPU: Ryzen AI',
        'Suport memorie: DDR5-5200'
    ]
),
(
    'Ryzen 9 7950X', 'AMD',
    'Flagship AMD cu 16 nuclee și 32 fire de execuție pentru workstation-uri și sarcini profesionale complexe.',
    '/resurse/imagini/produse/procesoare/ryzen9_7950x.jpg', 2999.99, 'N/A',
    'componente_hardware', 'procesoare',
    98, TRUE, FALSE,
    25, 'În stoc', 170,
    ARRAY[
        'Socket: AM5',
        'Arhitectura: Zen 4',
        'Nuclee: 16',
        'Thread-uri: 32',
        'Frecvența de bază: 4.5 GHz',
        'Frecvența Boost: 5.7 GHz',
        'Cache L3: 64MB',
        'TDP: 170W',
        'Grafica integrată: Nu',
        'Suport memorie: DDR5-5200'
    ]
);

-- Plăci de bază AMD
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'ROG CROSSHAIR X670E HERO', 'ASUS',
    'Placă de bază premium pentru procesoare AMD Ryzen 7000 și 8000, cu VRM robust în 18+2 faze, PCIe 5.0, DDR5 și iluminare Aura Sync avansată.',
    '/resurse/imagini/produse/placi_baza/rog_x670e_hero.jpg', 2999.99, 'Negru/RGB',
    'componente_hardware', 'placi_baza',
    88, TRUE, TRUE,
    15, 'În stoc', 30,
    ARRAY[
        'Socket: AM5',
        'Chipset: X670E',
        'Memorie suportată: DDR5',
        'Sloturi RAM: 4 x DIMM',
        'Capacitate maximă RAM: 128GB',
        'Sloturi M.2: 5',
        'PCIe x16: 2',
        'PCIe x1: 1',
        'Porturi USB: 2x USB4, 8x USB 3.2, 4x USB 2.0',
        'Wi-Fi: 6E',
        'Bluetooth: 5.2',
        'VRM: 18+2 faze',
        'Iluminare: Aura Sync RGB'
    ]
),
(
    'MPG X670E CARBON WIFI', 'MSI',
    'Placă de bază high-end cu design termic premium, suport DDR5 până la 7200MHz OC și conectivitate completă pentru platforme AMD de ultimă generație.',
    '/resurse/imagini/produse/placi_baza/mpg_x670e_carbon.jpg', 2199.99, 'Negru/RGB',
    'componente_hardware', 'placi_baza',
    85, TRUE, TRUE,
    15, 'În stoc', 28,
    ARRAY[
        'Socket: AM5',
        'Chipset: X670E',
        'Memorie suportată: DDR5',
        'Sloturi RAM: 4 x DIMM',
        'Capacitate maximă RAM: 128GB',
        'Sloturi M.2: 4',
        'PCIe x16: 2',
        'PCIe x1: 1',
        'Porturi USB: 1x USB4, 6x USB 3.2, 6x USB 2.0',
        'Wi-Fi: 6E',
        'Bluetooth: 5.2',
        'VRM: 16+2+1 faze',
        'Iluminare: Mystic Light RGB'
    ]
),
(
    'B650 AORUS ELITE AX', 'Gigabyte',
    'Placă de bază mid-range cu raport calitate-preț excelent, oferind VRM solid, WiFi 6E, suport DDR5 și M.2 PCIe 4.0 pentru build-uri AMD echilibrate.',
    '/resurse/imagini/produse/placi_baza/b650_aorus_elite.jpg', 1199.99, 'Negru',
    'componente_hardware', 'placi_baza',
    75, TRUE, TRUE,
    15, 'În stoc', 25,
    ARRAY[
        'Socket: AM5',
        'Chipset: B650',
        'Memorie suportată: DDR5',
        'Sloturi RAM: 4 x DIMM',
        'Capacitate maximă RAM: 128GB',
        'Sloturi M.2: 3',
        'PCIe x16: 1',
        'PCIe x1: 2',
        'Porturi USB: 6x USB 3.2, 6x USB 2.0',
        'Wi-Fi: 6E',
        'Bluetooth: 5.2',
        'VRM: 12+2+1 faze',
        'Iluminare: RGB Fusion 2.0'
    ]
);

-- Plăci de bază Intel
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'ROG MAXIMUS Z790 HERO', 'ASUS',
    'Placă de bază flagship pentru procesoarele Intel Gen 12, 13 și 14, cu VRM de înaltă performanță în 20+1 faze, conectivitate Thunderbolt 4 și suport DDR5.',
    '/resurse/imagini/produse/placi_baza/rog_z790_hero.jpg', 2799.99, 'Negru/RGB',
    'componente_hardware', 'placi_baza',
    90, TRUE, TRUE,
    15, 'În stoc', 32,
    ARRAY[
        'Socket: LGA1700',
        'Chipset: Z790',
        'Memorie suportată: DDR5',
        'Sloturi RAM: 4 x DIMM',
        'Capacitate maximă RAM: 128GB',
        'Sloturi M.2: 5',
        'PCIe x16: 2',
        'PCIe x1: 1',
        'Porturi USB: 2x Thunderbolt 4, 8x USB 3.2, 4x USB 2.0',
        'Wi-Fi: 6E',
        'Bluetooth: 5.2',
        'VRM: 20+1 faze',
        'Iluminare: Aura Sync RGB',
        'Overclocking: Da'
    ]
),
(
    'MEG Z790 ACE', 'MSI',
    'Placă de bază premium pentru enthusiaști cu suport pentru memorii DDR5 extreme, răcire avansată și caracteristici de overclocking pentru procesoarele Intel.',
    '/resurse/imagini/produse/placi_baza/meg_z790_ace.jpg', 2499.99, 'Negru/Gold',
    'componente_hardware', 'placi_baza',
    87, TRUE, TRUE,
    15, 'În stoc', 30,
    ARRAY[
        'Socket: LGA1700',
        'Chipset: Z790',
        'Memorie suportată: DDR5',
        'Sloturi RAM: 4 x DIMM',
        'Capacitate maximă RAM: 128GB',
        'Sloturi M.2: 6',
        'PCIe x16: 2',
        'PCIe x1: 1',
        'Porturi USB: 1x Thunderbolt 4, 8x USB 3.2, 4x USB 2.0',
        'Wi-Fi: 6E',
        'Bluetooth: 5.2',
        'VRM: 19+1+1 faze',
        'Iluminare: Mystic Light RGB',
        'Overclocking: Da'
    ]
),
(
    'MAG B760 TOMAHAWK WIFI', 'MSI',
    'Placă de bază mid-range ideală pentru build-uri Intel performante la preț accesibil, oferind VRM de calitate, conectivitate WiFi 6E și suport DDR5.',
    '/resurse/imagini/produse/placi_baza/mag_b760_tomahawk.jpg', 1099.99, 'Negru',
    'componente_hardware', 'placi_baza',
    72, TRUE, TRUE,
    15, 'În stoc', 22,
    ARRAY[
        'Socket: LGA1700',
        'Chipset: B760',
        'Memorie suportată: DDR5',
        'Sloturi RAM: 4 x DIMM',
        'Capacitate maximă RAM: 128GB',
        'Sloturi M.2: 3',
        'PCIe x16: 1',
        'PCIe x1: 2',
        'Porturi USB: 6x USB 3.2, 6x USB 2.0',
        'Wi-Fi: 6E',
        'Bluetooth: 5.2',
        'VRM: 13+1+1 faze',
        'Iluminare: RGB',
        'Overclocking: Parțial'
    ]
);


-- Plăci video NVIDIA RTX 50 Series
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'GeForce RTX 5090', 'NVIDIA',
    'Flagship GPU din noua generație Blackwell cu 32GB GDDR7, ray-tracing de generație nouă și AI accelerat. Performanță extremă pentru gaming 8K și aplicații profesionale.',
    '/resurse/imagini/produse/placi_video/rtx5090.jpg', 9499.99, 'Negru/RGB',
    'componente_hardware', 'placi_video',
    100, TRUE, FALSE,
    5, 'Stoc limitat', 450,
    ARRAY[
        'Chipset: NVIDIA GB202',
        'Memorie: 32GB GDDR7',
        'Bus memorie: 512-bit',
        'Interfața: PCI Express 5.0',
        'Porturi: 3x DisplayPort 2.1, 1x HDMI 2.1a',
        'Răcire: Triple Fan',
        'Alimentare: 16-Pin (12V-2x6)',
        'Dimensiuni: 336 x 140 x 61 mm',
        'Ray Tracing: 4th Gen RT Cores',
        'DLSS: 4.0 cu Frame Generation',
        'Boost Clock: 2520 MHz'
    ]
),
(
    'GeForce RTX 5080 GAMING X TRIO', 'MSI',
    'Placă video high-end bazată pe arhitectura Blackwell, cu cooling TRI FROZR 3, iluminare RGB Mystic Light, și performanță superioară în jocuri 4K.',
    '/resurse/imagini/produse/placi_video/rtx5080_msi.jpg', 6999.99, 'Negru/RGB',
    'componente_hardware', 'placi_video',
    95, TRUE, FALSE,
    5, 'Stoc limitat', 350,
    ARRAY[
        'Chipset: NVIDIA GB203',
        'Memorie: 24GB GDDR7',
        'Bus memorie: 384-bit',
        'Interfața: PCI Express 5.0',
        'Porturi: 3x DisplayPort 2.1, 1x HDMI 2.1a',
        'Răcire: MSI TRI FROZR 3',
        'Alimentare: 16-Pin (12V-2x6)',
        'Dimensiuni: 328 x 138 x 58 mm',
        'Ray Tracing: 4th Gen RT Cores',
        'DLSS: 4.0 cu Frame Generation',
        'Boost Clock: 2610 MHz'
    ]
);

-- Plăci video NVIDIA RTX 40 Series
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'GeForce RTX 4070 Ti SUPER GAMING X TRIO', 'MSI',
    'Placă video high-end cu 16GB GDDR6X și tehnologie DLSS 3.5, ideală pentru gaming 4K și ray-tracing avansat în cele mai noi jocuri.',
    '/resurse/imagini/produse/placi_video/rtx4070ti_super.jpg', 4299.99, 'Alb/RGB',
    'componente_hardware', 'placi_video',
    85, TRUE, FALSE,
    12, 'În stoc', 285,
    ARRAY[
        'Chipset: NVIDIA AD103',
        'Memorie: 16GB GDDR6X',
        'Bus memorie: 256-bit',
        'Interfața: PCI Express 4.0',
        'Porturi: 3x DisplayPort 1.4a, 1x HDMI 2.1',
        'Răcire: MSI TRI FROZR 2',
        'Alimentare: 16-Pin (12V-2x6)',
        'Dimensiuni: 328 x 140 x 56 mm',
        'Ray Tracing: 3rd Gen RT Cores',
        'DLSS: 3.5 cu Frame Generation',
        'Boost Clock: 2610 MHz'
    ]
),
(
    'GeForce RTX 4060 Ti DUAL OC', 'ASUS',
    'Placă video mid-range cu 8GB GDDR6, eficiență energetică ridicată și performanță optimă pentru gaming 1440p fluid și tehnologii AI.',
    '/resurse/imagini/produse/placi_video/rtx4060ti_asus.jpg', 1999.99, 'Negru',
    'componente_hardware', 'placi_video',
    75, TRUE, FALSE,
    12, 'În stoc', 160,
    ARRAY[
        'Chipset: NVIDIA AD106',
        'Memorie: 8GB GDDR6',
        'Bus memorie: 128-bit',
        'Interfața: PCI Express 4.0',
        'Porturi: 3x DisplayPort 1.4a, 1x HDMI 2.1',
        'Răcire: ASUS Axial-Tech',
        'Alimentare: 8-Pin',
        'Dimensiuni: 268 x 126 x 49 mm',
        'Ray Tracing: 3rd Gen RT Cores',
        'DLSS: 3.0 cu Frame Generation',
        'Boost Clock: 2540 MHz'
    ]
);

-- Plăci video AMD Radeon
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'Radeon RX 7900 XTX', 'AMD',
    'Cel mai puternic GPU AMD bazat pe arhitectura RDNA 4, cu 24GB GDDR7 și suport FSR 4.0, oferind performanță excepțională în jocuri și creare de conținut.',
    '/resurse/imagini/produse/placi_video/rx7900xtx.jpg', 5999.99, 'Alb',
    'componente_hardware', 'placi_video',
    92, TRUE, FALSE,
    12, 'În stoc', 320,
    ARRAY[
        'Chipset: AMD Navi 41',
        'Memorie: 24GB GDDR7',
        'Bus memorie: 384-bit',
        'Interfața: PCI Express 5.0',
        'Porturi: 2x DisplayPort 2.1, 1x HDMI 2.1a',
        'Răcire: Triple Fan',
        'Alimentare: 2x 8-Pin + 1x 6-Pin',
        'Dimensiuni: 320 x 134 x 56 mm',
        'Ray Tracing: RDNA 4 RT Accelerators',
        'FSR: 4.0 cu Frame Generation',
        'Game Clock: 2230 MHz'
    ]
),
(
    'Radeon RX 7800 XT TOXIC', 'Sapphire',
    'Placă video premium cu sistem de răcire hibrid (aer+lichid), iluminare ARGB și performanță excelentă pentru gaming 4K și ray-tracing.',
    '/resurse/imagini/produse/placi_video/rx7800xt_sapphire.jpg', 4499.99, 'Alb',
    'componente_hardware', 'placi_video',
    88, TRUE, FALSE,
    12, 'În stoc', 280,
    ARRAY[
        'Chipset: AMD Navi 42',
        'Memorie: 20GB GDDR7',
        'Bus memorie: 320-bit',
        'Interfața: PCI Express 5.0',
        'Porturi: 3x DisplayPort 2.1, 1x HDMI 2.1a',
        'Răcire: Hybrid (Aer+Lichid)',
        'Alimentare: 2x 8-Pin',
        'Dimensiuni: 305 x 136 x 62 mm',
        'Ray Tracing: RDNA 4 RT Accelerators',
        'FSR: 4.0 cu Frame Generation',
        'Game Clock: 2430 MHz'
    ]
),
(
    'Radeon RX 7700 XT NITRO+', 'Sapphire',
    'Placă video mid-range cu tehnologie AMD FSR 4.0, 16GB GDDR7 și eficiență energetică îmbunătățită pentru gaming 1440p și 4K.',
    '/resurse/imagini/produse/placi_video/rx7700xt_sapphire.jpg', 2999.99, 'Negru/Argintiu/RGB',
    'componente_hardware', 'placi_video',
    82, TRUE, FALSE,
    12, 'În stoc', 220,
    ARRAY[
        'Chipset: AMD Navi 43',
        'Memorie: 16GB GDDR7',
        'Bus memorie: 256-bit',
        'Interfața: PCI Express 5.0',
        'Porturi: 3x DisplayPort 2.1, 1x HDMI 2.1a',
        'Răcire: Sapphire NITRO+ Tri-X',
        'Alimentare: 2x 8-Pin',
        'Dimensiuni: 298 x 130 x 52 mm',
        'Ray Tracing: RDNA 4 RT Accelerators',
        'FSR: 4.0 cu Frame Generation',
        'Game Clock: 2565 MHz'
    ]
),
(
    'Radeon RX 7900 GRE', 'AMD',
    'GPU puternic bazat pe arhitectura RDNA 3 cu 16GB GDDR6, oferind performanță excelentă în jocuri AAA la rezoluții mari și productivitate.',
    '/resurse/imagini/produse/placi_video/rx7900gre.jpg', 2499.99, 'Negru/Roșu',
    'componente_hardware', 'placi_video',
    80, TRUE, FALSE,
    12, 'În stoc', 200,
    ARRAY[
        'Chipset: AMD Navi 31',
        'Memorie: 16GB GDDR6',
        'Bus memorie: 256-bit',
        'Interfața: PCI Express 4.0',
        'Porturi: 2x DisplayPort 2.1, 1x HDMI 2.1a',
        'Răcire: Dual Fan',
        'Alimentare: 2x 8-Pin',
        'Dimensiuni: 287 x 126 x 49 mm',
        'Ray Tracing: RDNA 3 RT Accelerators',
        'FSR: 3.0',
        'Game Clock: 2245 MHz'
    ]
);

-- Memorii RAM
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'Fury Beast 32GB DDR4 3200MHz CL16', 'Kingston',
    'Kit de memorie RAM DDR4 de 32GB (2x16GB) pentru sisteme gaming și multitasking, oferind un raport excelent calitate/preț și compatibilitate ridicată.',
    '/resurse/imagini/produse/memorii_ram/kingston_fury_beast.jpg', 449.99, 'Negru',
    'componente_hardware', 'memorii_ram',
    60, TRUE, FALSE,
    30, 'În stoc', 10,
    ARRAY[
        'Tip: DDR4',
        'Capacitate: 32GB (2x16GB)',
        'Frecvența: 3200MHz',
        'Latența: CL16-18-18-36',
        'Tensiune: 1.35V',
        'Iluminare: Nu',
        'Profil XMP: Da',
        'Kit dual channel: Da'
    ]
),
(
    'Trident Z RGB 32GB DDR4 3600MHz CL16', 'G.SKILL',
    'Kit de memorie premium DDR4 cu iluminare RGB full-length, performanță ridicată și profile XMP optimizate pentru platforme Intel și AMD.',
    '/resurse/imagini/produse/memorii_ram/gskill_trident_z_rgb.jpg', 699.99, 'Negru/RGB',
    'componente_hardware', 'memorii_ram',
    70, TRUE, FALSE,
    0, 'Indisponibil', 12,
    ARRAY[
        'Tip: DDR4',
        'Capacitate: 32GB (2x16GB)',
        'Frecvența: 3600MHz',
        'Latența: CL16-19-19-39',
        'Tensiune: 1.35V',
        'Iluminare: RGB full-length',
        'Profil XMP: Da',
        'Kit dual channel: Da'
    ]
),
(
    'Fury Beast 32GB DDR5 5200MHz CL40', 'Kingston',
    'Kit de memorie DDR5 entry-level (2x16GB) pentru platformele AMD AM5 și Intel LGA1700, oferind performanță de generație nouă la un preț accesibil.',
    '/resurse/imagini/produse/memorii_ram/kingston_fury_beast_ddr5.jpg', 749.99, 'Negru',
    'componente_hardware', 'memorii_ram',
    75, TRUE, FALSE,
    5, 'Stoc limitat', 8,
    ARRAY[
        'Tip: DDR5',
        'Capacitate: 32GB (2x16GB)',
        'Frecvența: 5200MHz',
        'Latența: CL40-40-40-76',
        'Tensiune: 1.25V',
        'Iluminare: Nu',
        'Profil XMP: Da',
        'Kit dual channel: Da'
    ]
),
(
    'Ripjaws S5 32GB DDR5 6000MHz CL32', 'G.SKILL',
    'Kit de memorie DDR5 de înaltă performanță, optimizat pentru gaming și creație de conținut pe ultimele platforme AMD și Intel.',
    '/resurse/imagini/produse/memorii_ram/gskill_ripjaws_s5.jpg', 999.99, 'Negru',
    'componente_hardware', 'memorii_ram',
    82, TRUE, FALSE,
    0, 'La comandă', 10,
    ARRAY[
        'Tip: DDR5',
        'Capacitate: 32GB (2x16GB)',
        'Frecvența: 6000MHz',
        'Latența: CL32-38-38-96',
        'Tensiune: 1.35V',
        'Iluminare: Nu',
        'Profil XMP: Da',
        'Kit dual channel: Da'
    ]
),
(
    'Dominator Platinum RGB 32GB DDR5 7200MHz CL34', 'Corsair',
    'Kit de memorie premium DDR5 cu iluminare RGB Capellix, răcire premium DHX și suport pentru overclocking extrem pe platformele high-end.',
    '/resurse/imagini/produse/memorii_ram/corsair_dominator_platinum.jpg', 1499.99, 'Negru/RGB',
    'componente_hardware', 'memorii_ram',
    90, TRUE, FALSE,
    2, 'Stoc limitat', 15,
    ARRAY[
        'Tip: DDR5',
        'Capacitate: 32GB (2x16GB)',
        'Frecvența: 7200MHz',
        'Latența: CL34-44-44-96',
        'Tensiune: 1.40V',
        'Iluminare: RGB Capellix',
        'Profil XMP: Da',
        'Răcire: DHX',
        'Kit dual channel: Da'
    ]
);

-- Stocare
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    '980 PRO 2TB NVMe PCIe 4.0', 'Samsung',
    'SSD de înaltă performanță M.2 NVMe PCIe 4.0 pentru gaming și creație de conținut profesional, cu viteze de citire de până la 7000 MB/s și scriere de până la 5100 MB/s.',
    '/resurse/imagini/produse/stocare/samsung_980pro.jpg', 899.99, 'Negru',
    'componente_hardware', 'stocare',
    95, TRUE, FALSE,
    22, 'În stoc', 8,
    ARRAY[
        'Tip: M.2 NVMe',
        'Capacitate: 2TB',
        'Interfața: PCIe 4.0 x4 NVMe 1.4',
        'Viteza citire: 7000 MB/s',
        'Viteza scriere: 5100 MB/s',
        'MTBF: 1.5 milioane ore',
        'Garanție: 5 ani'
    ]
),
(
    'SN850X 1TB NVMe PCIe 4.0', 'Western Digital',
    'SSD M.2 premium cu controller proprietar și viteză de citire de până la 7300 MB/s, ideal pentru gaming și aplicații intensive. Tehnologia Game Mode 2.0 optimizează performanța în timpul sesiunilor de joc.',
    '/resurse/imagini/produse/stocare/wd_sn850x.jpg', 599.99, 'Negru',
    'componente_hardware', 'stocare',
    88, TRUE, FALSE,
    0, 'La comandă', 7,
    ARRAY[
        'Tip: M.2 NVMe',
        'Capacitate: 1TB',
        'Interfața: PCIe 4.0 x4 NVMe 1.4',
        'Viteza citire: 7300 MB/s',
        'Viteza scriere: 6300 MB/s',
        'Game Mode 2.0: Da',
        'Garanție: 5 ani'
    ]
),
(
    'NV2 1TB NVMe PCIe 4.0', 'Kingston',
    'SSD M.2 cu raport calitate-preț excelent, oferind viteze de citire de până la 3500 MB/s și scriere de până la 2100 MB/s pentru utilizare zilnică și gaming casual.',
    '/resurse/imagini/produse/stocare/kingston_nv2.jpg', 349.99, 'Albastru',
    'componente_hardware', 'stocare',
    65, TRUE, FALSE,
    35, 'În stoc', 5,
    ARRAY[
        'Tip: M.2 NVMe',
        'Capacitate: 1TB',
        'Interfața: PCIe 4.0 x4 NVMe 1.3',
        'Viteza citire: 3500 MB/s',
        'Viteza scriere: 2100 MB/s',
        'Garanție: 3 ani'
    ]
),
(
    '870 EVO 1TB SATA', 'Samsung',
    'SSD SATA fiabil pentru upgrade de la HDD, cu viteze de citire de până la 560 MB/s și scriere de până la 530 MB/s. Tehnologia V-NAND și controller MKX oferă performanță de top în clasa SATA.',
    '/resurse/imagini/produse/stocare/samsung_870evo.jpg', 399.99, 'Negru',
    'componente_hardware', 'stocare',
    55, FALSE, FALSE,
    3, 'Stoc limitat', 3,
    ARRAY[
        'Tip: SSD SATA',
        'Capacitate: 1TB',
        'Interfața: SATA III (6 Gb/s)',
        'Viteza citire: 560 MB/s',
        'Viteza scriere: 530 MB/s',
        'Tehnologie: V-NAND',
        'Garanție: 5 ani'
    ]
),
(
    'Barracuda 4TB 7200RPM', 'Seagate',
    'Hard disk tradițional de mare capacitate pentru stocare masivă de date, arhive și backup. Ideal pentru biblioteci media extinse sau stocare secundară economică.',
    '/resurse/imagini/produse/stocare/seagate_barracuda.jpg', 429.99, 'Verde',
    'componente_hardware', 'stocare',
    35, FALSE, FALSE,
    0, 'Indisponibil', 12,
    ARRAY[
        'Tip: HDD',
        'Capacitate: 4TB',
        'Interfața: SATA III (6 Gb/s)',
        'Viteza rotație: 7200 RPM',
        'Cache: 256MB',
        'Viteza citire: 190 MB/s',
        'Garanție: 2 ani'
    ]
);

-- Surse alimentare
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'System Power 9 600W', 'be quiet!',
    'Sursă entry-level cu certificare 80+ Bronze, cabluri fixe și funcționare silențioasă pentru PC-uri de buget și sisteme office. Oferă stabilitate și eficiență la un preț accesibil.',
    '/resurse/imagini/produse/surse/bequiet_system_power9.jpg', 299.99, 'Negru',
    'componente_hardware', 'surse_alimentare',
    65, TRUE, FALSE,
    45, 'În stoc', 600,
    ARRAY[
        'Putere: 600W',
        'Eficiență: 85%',
        'Certificare: 80+ Bronze',
        'Protecții: OVP, UVP, OCP, OPP, SCP',
        'Cabluri: Fixe',
        'Ventilator: 120mm',
        'Garanție: 3 ani'
    ]
),
(
    'Pure Power 11 FM 750W', 'be quiet!',
    'Sursă mid-range cu certificare 80+ Gold, cabluri detașabile (full-modular) și ventilator silențios de 120mm. Echilibru excelent între preț și performanță pentru sisteme gaming.',
    '/resurse/imagini/produse/surse/bequiet_pure_power11.jpg', 599.99, 'Negru',
    'componente_hardware', 'surse_alimentare',
    75, TRUE, FALSE,
    0, 'La comandă', 750,
    ARRAY[
        'Putere: 750W',
        'Eficiență: 90%',
        'Certificare: 80+ Gold',
        'Protecții: OVP, UVP, OCP, OPP, SCP, OTP',
        'Cabluri: Full-modular',
        'Ventilator: 120mm silențios',
        'Garanție: 5 ani'
    ]
),
(
    'RM850x (2023)', 'Corsair',
    'Sursă premium cu certificare 80+ Gold, design full-modular, condensatori 100% japonezi și ventilator magnetic cu funcționare zero până la 40% încărcare. Performanță și fiabilitate de top pentru sisteme high-end.',
    '/resurse/imagini/produse/surse/corsair_rm850x.jpg', 799.99, 'Negru',
    'componente_hardware', 'surse_alimentare',
    85, TRUE, FALSE,
    4, 'Stoc limitat', 850,
    ARRAY[
        'Putere: 850W',
        'Eficiență: 90%',
        'Certificare: 80+ Gold',
        'Protecții: OVP, UVP, OCP, OPP, SCP, OTP, InRush',
        'Cabluri: Full-modular',
        'Ventilator: Zero RPM',
        'Condensatori: 100% japonezi',
        'Garanție: 10 ani'
    ]
),
(
    'Prime TX-1000', 'Seasonic',
    'Sursă de înaltă performanță cu certificare 80+ Titanium (eficiență peste 94%), cabluri premium full-modular și cooling hibrid pentru funcționare complet silențioasă la încărcare redusă.',
    '/resurse/imagini/produse/surse/seasonic_prime_tx1000.jpg', 1299.99, 'Negru',
    'componente_hardware', 'surse_alimentare',
    95, TRUE, FALSE,
    0, 'Indisponibil', 1000,
    ARRAY[
        'Putere: 1000W',
        'Eficiență: 94%',
        'Certificare: 80+ Titanium',
        'Protecții: OVP, UVP, OCP, OPP, SCP, OTP, InRush, Surge',
        'Cabluri: Full-modular premium',
        'Ventilator: Hibrid',
        'Garanție: 12 ani'
    ]
),
(
    'ROG Thor 1200P2', 'ASUS',
    'Sursă premium pentru enthusiaști, cu certificare 80+ Platinum, display OLED pentru monitorizare în timp real a puterii, iluminare RGB Aura Sync și răcire hibridă pentru performanță maximă în sisteme extreme.',
    '/resurse/imagini/produse/surse/asus_rog_thor1200p2.jpg', 1499.99, 'Negru/RGB',
    'componente_hardware', 'surse_alimentare',
    92, TRUE, FALSE,
    1, 'Stoc limitat', 1200,
    ARRAY[
        'Putere: 1200W',
        'Eficiență: 92%',
        'Certificare: 80+ Platinum',
        'Protecții: OVP, UVP, OCP, OPP, SCP, OTP, InRush, Surge',
        'Display: OLED pentru monitorizare',
        'Iluminare: RGB Aura Sync',
        'Cabluri: Full-modular',
        'Garanție: 10 ani'
    ]
);

-- Carcase
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    '4000D Airflow', 'Corsair',
    'Carcasă mid-tower cu design optimizat pentru flux de aer superior, panou frontal perforat și panouri laterale din sticlă securizată. Ideală pentru sisteme gaming cu răcire pe aer.',
    '/resurse/imagini/produse/carcase/corsair_4000d_airflow.jpg', 399.99, 'Negru',
    'componente_hardware', 'carcase',
    75, TRUE, FALSE,
    28, 'În stoc', 0,
    ARRAY[
        'Tip: Mid-Tower',
        'Material: Oțel, Sticlă Temperată',
        'Dimensiuni: 453 x 230 x 466 mm',
        'Ventilatoare incluse: 2x 120mm frontale',
        'Conectori: 1x USB 3.0, 1x USB 3.1 Type-C, Audio In/Out',
        'Suport radiator: Da (până la 360mm)',
        'Filtre praf: Da',
        'Suport pentru plăci video: până la 370mm',
        'Suport pentru coolere CPU: până la 170mm',
        'Management cabluri: Spațiu 25mm'
    ]
),
(
    'H7 Flow', 'NZXT',
    'Carcasă mid-tower premium cu design minimalist, interior spațios și funcționalitate USB-C frontală. Oferă excelent management al cablurilor și suport pentru răcire cu lichid.',
    '/resurse/imagini/produse/carcase/nzxt_h7_flow.jpg', 599.99, 'Alb',
    'componente_hardware', 'carcase',
    82, TRUE, FALSE,
    22, 'În stoc', 0,
    ARRAY[
        'Tip: Mid-Tower',
        'Material: Oțel, Sticlă Temperată',
        'Dimensiuni: 480 x 230 x 505 mm',
        'Ventilatoare incluse: 2x 140mm frontale',
        'Conectori: 2x USB 3.2 Gen 1, 1x USB 3.2 Gen 2 Type-C, Audio In/Out',
        'Suport radiator: Da (până la 360mm)',
        'Filtre praf: Da',
        'Suport pentru plăci video: până la 381mm',
        'Suport pentru coolere CPU: până la 185mm',
        'Management cabluri: Spațiu 30mm'
    ]
),
(
    'PC-O11 Dynamic Evo', 'Lian Li',
    'Carcasă premium cu design dual-chamber, panouri din sticlă temperată pe două laturi și suport extins pentru radiator. Perfectă pentru build-uri custom cu watercooling și iluminare RGB extinsă.',
    '/resurse/imagini/produse/carcase/lianli_o11dynamic_evo.jpg', 799.99, 'Negru/Argintiu',
    'componente_hardware', 'carcase',
    90, TRUE, FALSE,
    15, 'În stoc', 0,
    ARRAY[
        'Tip: Mid-Tower Dual-Chamber',
        'Material: Aluminiu, Oțel, Sticlă Temperată',
        'Dimensiuni: 462 x 285 x 476 mm',
        'Ventilatoare incluse: 0 (se vând separat)',
        'Conectori: 2x USB 3.0, 1x USB 3.1 Type-C, HD Audio',
        'Suport radiator: Da (până la 3x 360mm)',
        'Filtre praf: Da',
        'Suport pentru plăci video: până la 446mm',
        'Suport pentru coolere CPU: până la 155mm',
        'Management cabluri: Dual chamber design'
    ]
),
(
    'NR200P', 'Cooler Master',
    'Carcasă compactă Mini-ITX cu suport pentru plăci video full-size, opțiuni multiple de montare și panou lateral din sticlă temperată/mesh. Ideală pentru build-uri SFF puternice.',
    '/resurse/imagini/produse/carcase/coolermaster_nr200p.jpg', 499.99, 'Alb',
    'componente_hardware', 'carcase',
    78, TRUE, FALSE,
    0, 'La comandă', 0,
    ARRAY[
        'Tip: Mini-ITX',
        'Material: Oțel, Plastic, Sticlă Temperată/Mesh',
        'Dimensiuni: 360 x 185 x 274 mm',
        'Ventilatoare incluse: 2x 92mm',
        'Conectori: 2x USB 3.2 Gen 1, Audio In/Out',
        'Suport radiator: Da (până la 280mm)',
        'Filtre praf: Da',
        'Suport pentru plăci video: până la 330mm',
        'Suport pentru coolere CPU: până la 155mm',
        'Opțiuni montare: Verticală/Orizontală'
    ]
),
(
    'Enthoo Pro 2', 'Phanteks',
    'Carcasă full-tower de ultra-înaltă capacitate cu suport pentru două sisteme simultane, instalări extreme de watercooling și până la 12 HDD-uri. Destinată entuziaștilor și build-urilor workstation.',
    '/resurse/imagini/produse/carcase/phanteks_enthoo_pro2.jpg', 999.99, 'Negru',
    'componente_hardware', 'carcase',
    88, TRUE, FALSE,
    7, 'Stoc limitat', 0,
    ARRAY[
        'Tip: Full-Tower',
        'Material: Oțel, Sticlă Temperată, Nylon',
        'Dimensiuni: 580 x 240 x 560 mm',
        'Ventilatoare incluse: 3x 140mm',
        'Conectori: 4x USB 3.0, 1x USB 3.1 Type-C, Audio In/Out, Fan Controller',
        'Suport radiator: Da (până la 4x 360mm)',
        'Filtre praf: Da',
        'Suport pentru plăci video: până la 491mm',
        'Suport pentru coolere CPU: până la 192mm',
        'Capacitate stocare: până la 12x HDD + 6x SSD'
    ]
);

-- Coolere
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'Pure Rock 2', 'be quiet!',
    'Cooler CPU cu design single-tower, eficient și silențios pentru procesoare mainstream. Performanță ridicată la un preț accesibil, ideal pentru build-uri mid-range fără overclocking intensiv.',
    '/resurse/imagini/produse/coolere/bequiet_purerock2.jpg', 249.99, 'Negru',
    'componente_hardware', 'coolere',
    70, TRUE, FALSE,
    35, 'În stoc', 5,
    ARRAY[
        'Tip: Cooler CPU pe aer',
        'Design: Single Tower',
        'Socket: Intel LGA1700, LGA1200, LGA115x; AMD AM5, AM4',
        'Dimensiuni: 155 x 121 x 87 mm',
        'Ventilator: 120mm Pure Wings 2',
        'RPM: 500-1500',
        'Nivel zgomot: 13-26.8 dBA',
        'TDP suportat: până la 150W',
        'Iluminare: Nu',
        'Garanție: 3 ani'
    ]
),
(
    'Dark Rock Pro 4', 'be quiet!',
    'Cooler CPU premium dual-tower cu două ventilatoare Silent Wings, oferind performanță excelentă pentru procesoare high-end și overclocking. Tratament special de reducere a zgomotului și design stealth.',
    '/resurse/imagini/produse/coolere/bequiet_darkrockpro4.jpg', 499.99, 'Negru',
    'componente_hardware', 'coolere',
    85, TRUE, FALSE,
    22, 'În stoc', 8,
    ARRAY[
        'Tip: Cooler CPU pe aer',
        'Design: Dual Tower',
        'Socket: Intel LGA1700, LGA1200, LGA2066; AMD AM5, AM4',
        'Dimensiuni: 163 x 136 x 146 mm',
        'Ventilatoare: 2x Silent Wings 120mm/135mm',
        'RPM: 400-1500',
        'Nivel zgomot: 12.8-24.3 dBA',
        'TDP suportat: până la 250W',
        'Iluminare: Nu',
        'Garanție: 3 ani'
    ]
),
(
    'Kraken X53 RGB', 'NZXT',
    'Sistem de răcire cu lichid AIO cu radiator de 240mm, pompă RGB Infinity Mirror și ventilatoare AER RGB 2. Control intuitiv prin software CAM și compatibilitate cu toate platformele moderne.',
    '/resurse/imagini/produse/coolere/nzxt_krakenx53rgb.jpg', 799.99, 'Negru/RGB',
    'componente_hardware', 'coolere',
    82, TRUE, FALSE,
    0, 'Indisponibil', 12,
    ARRAY[
        'Tip: Cooler AIO (All-in-One)',
        'Radiator: 240mm',
        'Socket: Intel LGA1700, LGA1200, LGA115x; AMD AM5, AM4, TR4',
        'Dimensiuni radiator: 275 x 123 x 30 mm',
        'Ventilatoare: 2x AER RGB 2 120mm',
        'RPM: 500-1800',
        'Nivel zgomot: 21-36 dBA',
        'TDP suportat: până la 200W',
        'Iluminare: RGB Infinity Mirror',
        'Software: NZXT CAM'
    ]
),
(
    'Kraken Z73 RGB', 'NZXT',
    'Cooler AIO premium cu radiator de 360mm, afișaj LCD personalizabil și ventilatoare RGB pentru răcire intensivă. Permite monitorizarea în timp real a temperaturii CPU și afișarea de imagini sau GIF-uri personalizate.',
    '/resurse/imagini/produse/coolere/nzxt_krakenz73rgb.jpg', 1299.99, 'Negru/RGB',
    'componente_hardware', 'coolere',
    95, TRUE, FALSE,
    12, 'Stoc limitat', 15,
    ARRAY[
        'Tip: Cooler AIO (All-in-One)',
        'Radiator: 360mm',
        'Socket: Intel LGA1700, LGA1200, LGA2066; AMD AM5, AM4, TR4',
        'Dimensiuni radiator: 394 x 120 x 27 mm',
        'Ventilatoare: 3x AER RGB 2 120mm',
        'RPM: 500-1800',
        'Nivel zgomot: 21-36 dBA',
        'TDP suportat: până la 280W',
        'Display: LCD 2.36" personalizabil',
        'Iluminare: RGB + display LCD'
    ]
),
(
    'NH-D15 chromax.black', 'Noctua',
    'Cooler CPU premium cu design dual-tower și două ventilatoare NF-A15 HS-PWM pentru răcire extremă în configurație pasivă. Finisaj negru elegant, compatibilitate multi-socket și performanță de top pentru overclocking extrem și sisteme silent.',
    '/resurse/imagini/produse/coolere/noctua_nhd15_chromax.jpg', 599.99, 'Negru',
    'componente_hardware', 'coolere',
    92, TRUE, FALSE,
    20, 'În stoc', 0,
    ARRAY[
        'Tip: Cooler CPU pe aer',
        'Design: Dual Tower',
        'Socket: Intel LGA1700, LGA1200, LGA2066, LGA115x; AMD AM5, AM4, TR4',
        'Dimensiuni: 165 x 150 x 161 mm',
        'Ventilatoare: 2x NF-A15 HS-PWM 140mm',
        'RPM: 300-1500',
        'Nivel zgomot: 19.2-24.6 dBA',
        'TDP suportat: până la 220W',
        'Iluminare: Nu',
        'Garanție: 6 ani'
    ]
);


-- Tastaturi
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'G413 TKL SE', 'Logitech',
    'Tastatură gaming tenkeyless cu switch-uri mecanice tactile, iluminare LED albă și construcție din aluminiu rezistent. Design compact și performant pentru gaming casual.',
    '/resurse/imagini/produse/tastaturi/logitech_g413_tkl.jpg', 349.99, 'Negru',
    'periferice_gaming', 'tastaturi',
    70, TRUE, FALSE,
    42, 'În stoc', 3,
    ARRAY[
        'Tip: Gaming TKL (87 taste)',
        'Switch-uri: Tactile Romer-G',
        'Iluminare: LED alb',
        'Conectivitate: USB',
        'Material: Aluminiu 5052',
        'Dimensiuni: 356 x 127 x 40 mm',
        'Greutate: 708g',
        'Taste multimedia: Da',
        'Anti-ghosting: Da',
        'Cablu: USB detașabil'
    ]
),
(
    'HyperX Alloy Origins Core', 'HyperX',
    'Tastatură gaming TKL cu switch-uri HyperX Red liniare, iluminare RGB per-key, corp din aluminiu și memorie onboard pentru profiluri. Ideală pentru FPS și jocuri competitive.',
    '/resurse/imagini/produse/tastaturi/hyperx_alloy_origins_core.jpg', 499.99, 'Negru',
    'periferice_gaming', 'tastaturi',
    75, TRUE, FALSE,
    28, 'În stoc', 4,
    ARRAY[
        'Tip: Gaming TKL (87 taste)',
        'Switch-uri: HyperX Red (liniare)',
        'Iluminare: RGB per-key',
        'Conectivitate: USB',
        'Material: Aluminiu',
        'Dimensiuni: 360 x 132 x 34 mm',
        'Greutate: 900g',
        'Memorie onboard: Da',
        'Anti-ghosting: Da',
        'Software: HyperX NGENUITY'
    ]
),
(
    'ROG Azoth', 'ASUS',
    'Tastatură premium wireless 75% cu switch-uri ROG NX, display OLED personalizabil și conectivitate tri-mod (2.4GHz/Bluetooth/USB-C). Include Gasket Mount, dampening și lubrifierea din fabrică pentru o experiență premium.',
    '/resurse/imagini/produse/tastaturi/asus_rog_azoth.jpg', 1299.99, 'Negru/RGB',
    'periferice_gaming', 'tastaturi',
    92, TRUE, TRUE,
    15, 'Stoc limitat', 5,
    ARRAY[
        'Tip: Gaming wireless 75% (84 taste)',
        'Switch-uri: ROG NX (hot-swappable)',
        'Iluminare: RGB per-key',
        'Conectivitate: 2.4GHz/Bluetooth/USB-C',
        'Display: OLED 1.47" personalizabil',
        'Dimensiuni: 326 x 136 x 40 mm',
        'Greutate: 1190g',
        'Baterie: 4000mAh',
        'Gasket Mount: Da',
        'Lubrifiere din fabrică: Da',
        'Software: ROG Armoury Crate'
    ]
),
(
    'MX Keys S', 'Logitech',
    'Tastatură wireless premium pentru productivitate cu taste Perfect Stroke și Smart Illumination. Conectivitate multi-dispozitiv Bluetooth cu Logitech Flow pentru control fluid între calculatoare.',
    '/resurse/imagini/produse/tastaturi/logitech_mx_keys_s.jpg', 699.99, 'Grafit',
    'periferice_gaming', 'tastaturi',
    65, FALSE, TRUE,
    32, 'În stoc', 2,
    ARRAY[
        'Tip: Office wireless full-size (104 taste)',
        'Switch-uri: Scissor',
        'Iluminare: Smart Illumination',
        'Conectivitate: Bluetooth/Logi Bolt',
        'Material: Premium',
        'Dimensiuni: 430 x 132 x 20 mm',
        'Greutate: 810g',
        'Baterie: 10 zile (cu iluminare)',
        'Multi-dispozitiv: Da (3 dispozitive)',
        'Logitech Flow: Da',
        'Software: Logitech Options+'
    ]
),
(
    'K120', 'Logitech',
    'Tastatură office robustă și fiabilă, cu taste silențioase și rezistente la stropire. Design clasic full-size cu taste numerice și profil subțire pentru uz zilnic confortabil.',
    '/resurse/imagini/produse/tastaturi/logitech_k120.jpg', 89.99, 'Negru',
    'periferice_gaming', 'tastaturi',
    40, FALSE, FALSE,
    65, 'În stoc', 0,
    ARRAY[
        'Tip: Office cu fir full-size (104 taste)',
        'Switch-uri: Membrane',
        'Iluminare: Nu',
        'Conectivitate: USB',
        'Material: Plastic',
        'Dimensiuni: 450 x 155 x 23 mm',
        'Greutate: 550g',
        'Rezistență la stropire: Da',
        'Design: Profil subțire',
        'Taste silențioase: Da'
    ]
);

-- Mouse-uri
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'M110 Silent', 'Logitech',
    'Mouse office compact și silențios, ideal pentru utilizare zilnică. Design ambidextru cu senzor optic de precizie și butoane cu tehnologie SilentTouch pentru operare discretă.',
    '/resurse/imagini/produse/mouse/logitech_m110.jpg', 69.99, 'Negru',
    'periferice_gaming', 'mouse_gaming',
    35, FALSE, FALSE,
    55, 'În stoc', 0,
    ARRAY[
        'Tip: Office cu fir',
        'Senzor: Optic 1000 DPI',
        'Butoane: 3',
        'Conectivitate: USB',
        'Design: Ambidextru',
        'Greutate: 85g',
        'Tehnologie: SilentTouch',
        'Iluminare: Nu',
        'Scroll: Standard',
        'Cablu: 1.8m'
    ]
),
(
    'MX Master 3S', 'Logitech',
    'Mouse wireless ergonomic premium pentru productivitate, cu senzor de 8000 DPI pe orice suprafață, Quiet Clicks și scroll electromagnetic MagSpeed. Conectivitate multi-dispozitiv prin Bluetooth sau receptor Logi Bolt.',
    '/resurse/imagini/produse/mouse/logitech_mx_master_3s.jpg', 499.99, 'Grafit',
    'periferice_gaming', 'mouse_gaming',
    70, FALSE, TRUE,
    24, 'În stoc', 1,
    ARRAY[
        'Tip: Office wireless',
        'Senzor: Darkfield 8000 DPI',
        'Butoane: 7 (personalizabile)',
        'Conectivitate: Bluetooth/Logi Bolt',
        'Design: Ergonomic pentru mâna dreaptă',
        'Greutate: 141g',
        'Scroll: MagSpeed electromagnetic',
        'Baterie: 70 zile',
        'Multi-dispozitiv: Da (3 dispozitive)',
        'Logitech Flow: Da',
        'Software: Logitech Options+'
    ]
),
(
    'G305 LIGHTSPEED', 'Logitech',
    'Mouse gaming wireless cu tehnologie LIGHTSPEED pentru conexiune de 1ms, senzor HERO 12K și autonomie extinsă de până la 250 ore cu o singură baterie AA. Design ușor și compact pentru sesiuni de gaming portabile.',
    '/resurse/imagini/produse/mouse/logitech_g305.jpg', 249.99, 'Negru',
    'periferice_gaming', 'mouse_gaming',
    78, TRUE, TRUE,
    38, 'În stoc', 0,
    ARRAY[
        'Tip: Gaming wireless',
        'Senzor: HERO 12000 DPI',
        'Butoane: 6 (programabile)',
        'Conectivitate: LIGHTSPEED wireless',
        'Design: Ambidextru',
        'Greutate: 99g',
        'Latență: 1ms',
        'Baterie: 250 ore (1x AA)',
        'Tracking: 400 IPS',
        'Accelerație: 40G',
        'Software: Logitech G HUB'
    ]
),
(
    'DeathAdder V3 Pro', 'Razer',
    'Mouse gaming wireless ultra-ușor (63g) cu senzor optic Focus Pro 30K, switch-uri optice Gen-3 cu durabilitate de 90 milioane de clicuri și conectivitate HyperSpeed. Ergonomie perfecționată pentru sesiuni intensive de gaming.',
    '/resurse/imagini/produse/mouse/razer_deathadder_v3_pro.jpg', 699.99, 'Alb',
    'periferice_gaming', 'mouse_gaming',
    88, TRUE, TRUE,
    18, 'Stoc limitat', 0,
    ARRAY[
        'Tip: Gaming wireless',
        'Senzor: Focus Pro 30K (30000 DPI)',
        'Butoane: 5 (programabile)',
        'Conectivitate: HyperSpeed wireless',
        'Design: Ergonomic pentru mâna dreaptă',
        'Greutate: 63g',
        'Switch-uri: Optice Gen-3 (90M clicuri)',
        'Baterie: 90 ore',
        'Tracking: 750 IPS',
        'Accelerație: 50G',
        'Software: Razer Synapse 3'
    ]
),
(
    'Viper V2 Pro', 'Razer',
    'Mouse gaming wireless ultra-performant cu greutate minimă de 58g, senzor Focus Pro 30K, switch-uri optice Gen-3 și conectivitate HyperSpeed cu latență extrem de redusă. Construit pentru esports și jucători profesioniști.',
    '/resurse/imagini/produse/mouse/razer_viper_v2_pro.jpg', 799.99, 'Negru',
    'periferice_gaming', 'mouse_gaming',
    92, TRUE, TRUE,
    12, 'Stoc limitat', 0,
    ARRAY[
        'Tip: Gaming wireless',
        'Senzor: Focus Pro 30K (30000 DPI)',
        'Butoane: 5 (programabile)',
        'Conectivitate: HyperSpeed wireless',
        'Design: Ambidextru',
        'Greutate: 58g',
        'Switch-uri: Optice Gen-3 (90M clicuri)',
        'Baterie: 80 ore',
        'Tracking: 750 IPS',
        'Accelerație: 50G',
        'Software: Razer Synapse 3'
    ]
);

-- Monitoare
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'V24i-10', 'Lenovo',
    'Monitor office de 23.8" cu panou IPS Full HD, design fără ramă pe trei laturi și tehnologie anti-flicker pentru productivitate zilnică. Suport cu înclinare ergonomică și conectivitate HDMI/VGA.',
    '/resurse/imagini/produse/monitoare/lenovo_v24i.jpg', 499.99, 'Negru',
    'periferice_gaming', 'monitoare',
    45, FALSE, FALSE,
    45, 'În stoc', 25,
    ARRAY[
        'Diagonala: 23.8"',
        'Rezoluție: 1920x1080 (Full HD)',
        'Tip panou: IPS',
        'Rata refresh: 75Hz',
        'Timp răspuns: 4ms',
        'Luminozitate: 250 cd/m²',
        'Contrast: 1000:1',
        'Porturi: 1x HDMI 1.4, 1x VGA, 1x Audio Out',
        'Adaptive sync: AMD FreeSync',
        'Boxe integrate: Da',
        'Dimensiuni: 540 x 323 x 180 mm',
        'Greutate: 4.2kg',
        'Suport ergonomic: Tilt'
    ]
),
(
    'G24F 2', 'Gigabyte',
    'Monitor gaming de 24" cu panou FAST IPS Full HD 180Hz, 1ms MPRT și tehnologie FreeSync Premium pentru gaming fluid. Design elegant cu iluminare RGB FUSION 2.0 și funcții de asistență pentru gaming.',
    '/resurse/imagini/produse/monitoare/gigabyte_g24f2.jpg', 899.99, 'Negru',
    'periferice_gaming', 'monitoare',
    75, TRUE, FALSE,
    28, 'În stoc', 35,
    ARRAY[
        'Diagonala: 24"',
        'Rezoluție: 1920x1080 (Full HD)',
        'Tip panou: FAST IPS',
        'Rata refresh: 180Hz',
        'Timp răspuns: 1ms MPRT',
        'Luminozitate: 400 cd/m²',
        'Contrast: 1000:1',
        'Porturi: 2x HDMI 2.0, 1x DisplayPort 1.2, 1x Audio Out',
        'Adaptive sync: AMD FreeSync Premium',
        'Boxe integrate: Nu',
        'Dimensiuni: 539 x 422 x 153 mm',
        'Greutate: 5.8kg',
        'Iluminare: RGB FUSION 2.0',
        'Gaming features: Crosshair, OSD Sidekick'
    ]
),
(
    'G32QC', 'Gigabyte',
    'Monitor gaming curbat de 31.5" cu panou VA QHD 165Hz, 1ms MPRT și acoperire sRGB 94%. Tehnologie FreeSync Premium Pro pentru gaming HDR fără tearing și efecte de iluminare RGB.',
    '/resurse/imagini/produse/monitoare/gigabyte_g32qc.jpg', 1499.99, 'Negru',
    'periferice_gaming', 'monitoare',
    82, TRUE, FALSE,
    18, 'În stoc', 50,
    ARRAY[
        'Diagonala: 31.5"',
        'Rezoluție: 2560x1440 (QHD)',
        'Tip panou: VA curbat',
        'Curbură: 1500R',
        'Rata refresh: 165Hz',
        'Timp răspuns: 1ms MPRT',
        'Luminozitate: 350 cd/m²',
        'Contrast: 3000:1',
        'Porturi: 2x HDMI 2.0, 1x DisplayPort 1.4, 1x Audio Out',
        'Adaptive sync: AMD FreeSync Premium Pro',
        'HDR: HDR400',
        'Acoperire culoare: 94% sRGB',
        'Boxe integrate: Nu',
        'Dimensiuni: 700 x 481 x 248 mm',
        'Greutate: 8.5kg'
    ]
),
(
    'Odyssey G8 OLED', 'Samsung',
    'Monitor gaming premium de 34" ultra-wide (21:9) cu panou OLED QHD, refresh de 175Hz și timp de răspuns 0.03ms. Curbură 1800R, HDR True Black 400 și design futurist Neo Quantum.',
    '/resurse/imagini/produse/monitoare/samsung_odyssey_g8.jpg', 3999.99, 'Negru/Alb',
    'periferice_gaming', 'monitoare',
    95, TRUE, FALSE,
    8, 'Stoc limitat', 75,
    ARRAY[
        'Diagonala: 34"',
        'Rezoluție: 3440x1440 (UWQHD)',
        'Tip panou: OLED curbat',
        'Curbură: 1800R',
        'Rata refresh: 175Hz',
        'Timp răspuns: 0.03ms',
        'Luminozitate: 250 cd/m²',
        'Contrast: 1,000,000:1',
        'Porturi: 1x HDMI 2.1, 1x DisplayPort 1.4, 2x USB 3.0, 1x Audio Out',
        'Adaptive sync: NVIDIA G-Sync',
        'HDR: HDR True Black 400',
        'Acoperire culoare: 99% DCI-P3',
        'Boxe integrate: Nu',
        'Dimensiuni: 807 x 381 x 251 mm',
        'Greutate: 12.7kg',
        'Gaming Hub: Da'
    ]
),
(
    'ProArt PA32UCG-K', 'ASUS',
    'Monitor profesional de 32" cu panou Mini-LED IPS 4K, certificare DisplayHDR 1400, calibrare hardware și acoperire 98% DCI-P3. Creat pentru profesioniști în editare foto/video, cu conectivitate completă inclusiv Thunderbolt 4.',
    '/resurse/imagini/produse/monitoare/asus_proart_pa32ucg.jpg', 9999.99, 'Negru',
    'periferice_gaming', 'monitoare',
    98, FALSE, FALSE,
    5, 'Stoc limitat', 120,
    ARRAY[
        'Diagonala: 32"',
        'Rezoluție: 3840x2160 (4K UHD)',
        'Tip panou: Mini-LED IPS',
        'Rata refresh: 120Hz',
        'Timp răspuns: 4ms',
        'Luminozitate: 1400 cd/m²',
        'Contrast: 1000:1',
        'Porturi: 2x HDMI 2.1, 1x DisplayPort 1.4, 1x Thunderbolt 4, 4x USB 3.2, 1x Audio Out',
        'Adaptive sync: NVIDIA G-Sync Ultimate',
        'HDR: DisplayHDR 1400',
        'Acoperire culoare: 98% DCI-P3, 99% Adobe RGB',
        'Calibrare: Hardware calibration',
        'Boxe integrate: Da',
        'Dimensiuni: 727 x 481 x 215 mm',
        'Greutate: 14.5kg',
        'Software: ProArt Calibration'
    ]
);

-- Căști
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'G335', 'Logitech',
    'Căști gaming ușoare și confortabile, cu microfon flip-to-mute și difuzoare de 40mm. Design colorat și ergonomic pentru sesiuni de gaming prelungite la un preț accesibil.',
    '/resurse/imagini/produse/casti/logitech_g335.jpg', 249.99, 'Negru',
    'periferice_gaming', 'casti_audio',
    65, TRUE, FALSE,
    42, 'În stoc', 0,
    ARRAY[
        'Tip: Gaming cu fir',
        'Conectivitate: Jack 3.5mm',
        'Difuzoare: 40mm',
        'Impedanță: 36 ohm',
        'Răspuns frecvență: 20Hz-20kHz',
        'Microfon: Da (flip-to-mute)',
        'Control volum: Da',
        'Anulare zgomot: Nu',
        'Tip fixare: On Ear',
        'Greutate: 240g',
        'Lungime cablu: 1.8m',
        'Compatibilitate: PC, PlayStation, Xbox, Nintendo Switch'
    ]
),
(
    'BlackShark V2 Pro', 'Razer',
    'Căști gaming wireless premium cu microfon detașabil HyperClear, tehnologie Triforce Titanium de 50mm și conectivitate Razer HyperSpeed. Sunet surround THX Spatial Audio și autonomie de 24 ore.',
    '/resurse/imagini/produse/casti/razer_blackshark_v2_pro.jpg', 899.99, 'Negru',
    'periferice_gaming', 'casti_audio',
    88, TRUE, TRUE,
    18, 'În stoc', 2,
    ARRAY[
        'Tip: Gaming wireless',
        'Conectivitate: 2.4GHz wireless',
        'Difuzoare: Triforce Titanium 50mm',
        'Impedanță: 32 ohm',
        'Răspuns frecvență: 12Hz-28kHz',
        'Microfon: Da (detașabil HyperClear)',
        'Control volum: Da',
        'Anulare zgomot: Da (pasivă)',
        'Tip fixare: Over Ear',
        'Greutate: 320g',
        'Baterie: 24 ore',
        'THX Spatial Audio: Da',
        'Software: Razer Synapse'
    ]
),
(
    'WH-1000XM5', 'Sony',
    'Căști wireless cu cel mai avansat sistem de anulare a zgomotului, 8 microfoane cu AI pentru apeluri clare și drivere de 30mm optimizate. Autonomie de 30 ore și încărcare rapidă pentru utilizare profesională.',
    '/resurse/imagini/produse/casti/sony_wh1000xm5.jpg', 1699.99, 'Argintiu',
    'periferice_gaming', 'casti_audio',
    92, FALSE, TRUE,
    15, 'Stoc limitat', 3,
    ARRAY[
        'Tip: Premium wireless',
        'Conectivitate: Bluetooth 5.2',
        'Difuzoare: 30mm',
        'Impedanță: 48 ohm',
        'Răspuns frecvență: 4Hz-40kHz',
        'Microfon: Da (8 microfoane AI)',
        'Control volum: Touch controls',
        'Anulare zgomot: Da (Industry-leading ANC)',
        'Tip fixare: Over Ear',
        'Greutate: 250g',
        'Baterie: 30 ore (cu ANC)',
        'Încărcare rapidă: 3 minute = 3 ore',
        'LDAC Hi-Res: Da',
        'Software: Sony Headphones Connect'
    ]
),
(
    'Zone Wireless Plus', 'Logitech',
    'Căști office business wireless cu microfon certificat pentru aplicații de conferință, anulare activă a zgomotului și conectivitate multi-dispozitiv. Include receptor Unifying+ pentru conexiune simultană cu perifericele wireless.',
    '/resurse/imagini/produse/casti/logitech_zone_wireless.jpg', 1099.99, 'Grafit',
    'periferice_gaming', 'casti_audio',
    75, FALSE, TRUE,
    22, 'În stoc', 1,
    ARRAY[
        'Tip: Business wireless',
        'Conectivitate: Bluetooth/Unifying+',
        'Difuzoare: 40mm',
        'Impedanță: 32 ohm',
        'Răspuns frecvență: 20Hz-20kHz',
        'Microfon: Da (certificat Teams)',
        'Control volum: Da',
        'Anulare zgomot: Da (activă)',
        'Tip fixare: Over Ear',
        'Greutate: 309g',
        'Baterie: 14 ore (talk time)',
        'Multi-dispozitiv: Da (2 dispozitive)',
        'Certificări: Microsoft Teams, Zoom, Google Meet',
        'Software: Logitech Options+'
    ]
),
(
    'HD 660S', 'Sennheiser',
    'Căști audiophile de referință cu impedanță redusă de 150 ohmi, drivere dinamice avansate și design deschis pentru audiție critică. Construcție premium și cablu detașabil pentru experiența audio de înaltă fidelitate.',
    '/resurse/imagini/produse/casti/sennheiser_hd660s.jpg', 1999.99, 'Negru/Gri',
    'periferice_gaming', 'casti_audio',
    95, FALSE, FALSE,
    8, 'Stoc limitat', 0,
    ARRAY[
        'Tip: Audiophile cu fir',
        'Conectivitate: Jack 6.3mm (adaptor 3.5mm inclus)',
        'Difuzoare: Dinamice avansate',
        'Impedanță: 150 ohm',
        'Răspuns frecvență: 10Hz-41kHz',
        'Microfon: Nu',
        'Control volum: Nu',
        'Anulare zgomot: Nu (design deschis)',
        'Tip fixare: Over Ear (design deschis)',
        'Greutate: 260g',
        'Cablu: Detașabil 3m',
        'Distorsiuni: < 0.04%',
        'Sensibilitate: 104 dB',
        'Construcție: Premium (plastic de înaltă calitate)'
    ]
);

-- Mousepad-uri
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'QcK Medium', 'SteelSeries',
    'Mousepad gaming clasic, dimensiune medie cu suprafață din material textil optimizat pentru precizie și viteză. Baza antialunecare din cauciuc și margini cusute pentru durabilitate.',
    '/resurse/imagini/produse/mousepad/steelseries_qck_medium.jpg', 79.99, 'Negru',
    'periferice_gaming', 'mousepad',
    65, TRUE, FALSE,
    40, 'În stoc', 0,
    ARRAY[
        'Tip: Gaming textil',
        'Dimensiuni: 320 x 270 x 2 mm',
        'Material: Material textil optimizat',
        'Bază: Cauciuc antialunecare',
        'Margini: Cusute pentru durabilitate',
        'Suprafață: Micro-textură echilibrată',
        'Compatibilitate: Mouse optic și laser',
        'Iluminare: Nu',
        'Greutate: 90g'
    ]
),
(
    'Gigantus V2 XXL', 'Razer',
    'Mousepad de dimensiune extinsă (940x410mm) cu micro-textură echilibrată pentru control și viteză. Baza antialunecare din cauciuc gros și margini cusute pentru stabilitate în timpul sesiunilor de gaming intense.',
    '/resurse/imagini/produse/mousepad/razer_gigantus_v2_xxl.jpg', 159.99, 'Negru',
    'periferice_gaming', 'mousepad',
    70, TRUE, FALSE,
    25, 'În stoc', 0,
    ARRAY[
        'Tip: Gaming extended textil',
        'Dimensiuni: 940 x 410 x 4 mm',
        'Material: Material textil premium',
        'Bază: Cauciuc gros antialunecare',
        'Margini: Cusute anti-fraying',
        'Suprafață: Micro-textură echilibrată',
        'Compatibilitate: Mouse optic și laser',
        'Iluminare: Nu',
        'Greutate: 350g'
    ]
),
(
    'Firefly V2 RGB', 'Razer',
    'Mousepad gaming hard cu iluminare RGB Chroma pe întreaga circumferință (19 zone). Suprafață micro-texturată optimizată pentru tracking optic precis și conectivitate USB pentru sincronizare cu perifericele Razer.',
    '/resurse/imagini/produse/mousepad/razer_firefly_v2.jpg', 249.99, 'Negru/RGB',
    'periferice_gaming', 'mousepad',
    80, TRUE, FALSE,
    15, 'Stoc limitat', 2,
    ARRAY[
        'Tip: Gaming hard surface RGB',
        'Dimensiuni: 355 x 255 x 3 mm',
        'Material: Suprafață rigidă (hard pad)',
        'Bază: Cauciuc antialunecare',
        'Iluminare: RGB Chroma (19 zone)',
        'Conectivitate: USB pentru RGB',
        'Suprafață: Micro-texturată optimizată',
        'Compatibilitate: Mouse optic și laser',
        'Software: Razer Synapse 3',
        'Greutate: 460g'
    ]
),
(
    'MM700 RGB', 'Corsair',
    'Mousepad extended RGB (930x400mm) ce acoperă întreaga zonă de lucru, cu iluminare pe trei laturi și controller integrat. Suprafață din material textil cu frecare redusă și bază groasă din cauciuc pentru confort în timpul utilizării îndelungate.',
    '/resurse/imagini/produse/mousepad/corsair_mm700.jpg', 229.99, 'Negru/RGB',
    'periferice_gaming', 'mousepad',
    75, TRUE, FALSE,
    18, 'În stoc', 3,
    ARRAY[
        'Tip: Gaming extended RGB textil',
        'Dimensiuni: 930 x 400 x 4 mm',
        'Material: Material textil cu frecare redusă',
        'Bază: Cauciuc groasă antialunecare',
        'Iluminare: RGB pe trei laturi',
        'Conectivitate: USB pentru RGB și control',
        'Controller: Integrat pentru control RGB',
        'Compatibilitate: Mouse optic și laser',
        'Software: Corsair iCUE',
        'Greutate: 700g'
    ]
);

-- Software & Sisteme de operare
INSERT INTO produse (
    nume, brand, descriere, imagine, pret, culoare,
    categorie, subcategorie,
    performanta_score, gaming_ready, wireless_support,
    stoc, stoc_status, consum_watt,
    specificatii_tehnice
) VALUES
(
    'Windows 11 Pro', 'Microsoft',
    'Sistem de operare premium cu toate funcțiile Windows 11 plus instrumente avansate de securitate, BitLocker, Windows Sandbox și Remote Desktop. Ideal pentru profesioniști și utilizatori care necesită funcționalități avansate de securitate și administrare.',
    '/resurse/imagini/produse/software/windows11_pro.jpg', 999.99, 'N/A',
    'software_licente', 'sisteme_operare',
    90, TRUE, FALSE,
    50, 'În stoc', 0,
    ARRAY[
        'Tip: Sistem de operare',
        'Versiune: Windows 11 Pro',
        'Arhitectura: x64',
        'Mod comercializare: Cod de activare',
        'Utilizatori: 1',
        'Durata licență: Nelimitat',
        'Tip licențiere: Retail',
        'Limbă: Română/Engleză',
        'Funcții Pro: BitLocker, Remote Desktop, Hyper-V',
        'Securitate: Windows Defender, Windows Sandbox',
        'Suport: Microsoft Update lifecycle'
    ]
),
(
    'Windows 11 Home', 'Microsoft',
    'Sistem de operare modern cu interfață redesenată, optimizat pentru productivitate și divertisment. Include Microsoft Store, Xbox Game Pass, și experiență de gaming îmbunătățită cu DirectStorage și Auto HDR.',
    '/resurse/imagini/produse/software/windows11_home.jpg', 549.99, 'N/A',
    'software_licente', 'sisteme_operare',
    80, TRUE, FALSE,
    65, 'În stoc', 0,
    ARRAY[
        'Tip: Sistem de operare',
        'Versiune: Windows 11 Home',
        'Arhitectura: x64',
        'Mod comercializare: Cod de activare',
        'Utilizatori: 1',
        'Durata licență: Nelimitat',
        'Tip licențiere: OEM',
        'Limbă: Română/Engleză',
        'Gaming: DirectStorage, Auto HDR, Xbox Game Pass',
        'Store: Microsoft Store',
        'Suport: Microsoft Update lifecycle'
    ]
),
(
    'Windows 10 Pro', 'Microsoft',
    'Sistem de operare stabil și matur, ideal pentru utilizatorii care preferă o interfață tradițională și compatibilitate extinsă cu aplicații legacy. Include funcții de securitate și business avansate precum BitLocker și Hyper-V.',
    '/resurse/imagini/produse/software/windows10_pro.jpg', 799.99, 'N/A',
    'software_licente', 'sisteme_operare',
    75, FALSE, FALSE,
    40, 'În stoc', 0,
    ARRAY[
        'Tip: Sistem de operare',
        'Versiune: Windows 10 Pro',
        'Arhitectura: x64',
        'Mod comercializare: USB',
        'Utilizatori: 1',
        'Durata licență: Nelimitat',
        'Tip licențiere: Retail',
        'Limbă: Engleză',
        'Funcții Pro: BitLocker, Remote Desktop, Hyper-V',
        'Compatibilitate: Aplicații legacy extinse',
        'Suport: Până în octombrie 2025'
    ]
),
(
    'Windows 10 Home', 'Microsoft',
    'Sistem de operare stabil și fiabil pentru utilizatorii casnici, cu interfață familiară și acces la Microsoft Store. Perfectă pentru productivitate, divertisment și utilizare zilnică, inclusiv suport pentru actualizări de securitate regulate.',
    '/resurse/imagini/produse/software/windows10_home.jpg', 449.99, 'N/A',
    'software_licente', 'sisteme_operare',
    70, FALSE, FALSE,
    80, 'În stoc', 0,
    ARRAY[
        'Tip: Sistem de operare',
        'Versiune: Windows 10 Home',
        'Arhitectura: x64',
        'Mod comercializare: Cod de activare',
        'Utilizatori: 1',
        'Durata licență: Nelimitat',
        'Tip licențiere: OEM',
        'Limbă: Română/Engleză',
        'Store: Microsoft Store',
        'Cortana: Asistent virtual',
        'Suport: Până în octombrie 2025'
    ]
),
(
    'Microsoft Office 365 Personal', 'Microsoft',
    'Abonament anual pentru aplicațiile Office premium (Word, Excel, PowerPoint, Outlook) cu 1TB stocare OneDrive și actualizări permanente. Include versiuni desktop, web și mobile, plus funcții exclusive disponibile doar abonaților.',
    '/resurse/imagini/produse/software/office365_personal.jpg', 299.99, 'N/A',
    'software_licente', 'aplicatii_software',
    85, FALSE, FALSE,
    75, 'În stoc', 0,
    ARRAY[
        'Tip: Suită de productivitate (abonament)',
        'Aplicații: Word, Excel, PowerPoint, Outlook',
        'Arhitectura: x64',
        'Mod comercializare: Cod de activare',
        'Utilizatori: 1',
        'Durata licență: 1 An',
        'Tip licențiere: Retail',
        'Limbă: Română/Engleză',
        'OneDrive: 1TB stocare cloud',
        'Platforme: Desktop, Web, Mobile',
        'Actualizări: Permanente'
    ]
),
(
    'Microsoft Office Home & Business 2024', 'Microsoft',
    'Licență perpetuă pentru Word, Excel, PowerPoint și Outlook. Soluție ideală pentru utilizatorii care preferă plata unică în locul abonamentului, potrivită pentru uz personal și afaceri mici.',
    '/resurse/imagini/produse/software/office_homebusiness.jpg', 1199.99, 'N/A',
    'software_licente', 'aplicatii_software',
    80, FALSE, FALSE,
    42, 'În stoc', 0,
    ARRAY[
        'Tip: Suită de productivitate (licență perpetuă)',
        'Aplicații: Word, Excel, PowerPoint, Outlook',
        'Arhitectura: x64',
        'Mod comercializare: Cod de activare',
        'Utilizatori: 1',
        'Durata licență: Nelimitat',
        'Tip licențiere: Retail',
        'Limbă: Română/Engleză',
        'Versiune: 2024',
        'Actualizări: Patch-uri de securitate',
        'Platforme: Desktop'
    ]
),
(
    'Norton 360 Standard', 'NortonLifeLock',
    'Suită completă de securitate pentru 5 dispozitive (PC, Mac, smartphone și tablet) ce include antivirus, firewall, password manager, VPN nelimitat, backup în cloud (50GB) și Dark Web Monitoring pentru protecție completă online.',
    '/resurse/imagini/produse/software/norton360.jpg', 349.99, 'N/A',
    'software_licente', 'aplicatii_software',
    88, FALSE, FALSE,
    55, 'În stoc', 0,
    ARRAY[
        'Tip: Suită de securitate',
        'Protecție: Antivirus, Firewall, Anti-malware',
        'Arhitectura: x64',
        'Mod comercializare: Cod de activare',
        'Utilizatori/Dispozitive: 5',
        'Durata licență: 1 An',
        'Tip licențiere: Retail',
        'Limbă: Română/Engleză',
        'VPN: Nelimitat',
        'Backup: 50GB cloud',
        'Dark Web Monitoring: Da',
        'Password Manager: Da'
    ]
),
(
    'Adobe Creative Cloud', 'Adobe',
    'Colecție completă de peste 20 aplicații creative de la Adobe, inclusiv Photoshop, Illustrator, Premiere Pro și After Effects. Include 100GB stocare în cloud, mii de fonturi și resurse creative pentru profesioniști și entuziaști.',
    '/resurse/imagini/produse/software/adobe_cc.jpg', 2499.99, 'N/A',
    'software_licente', 'aplicatii_software',
    95, FALSE, FALSE,
    30, 'În stoc', 0,
    ARRAY[
        'Tip: Suite creative (abonament)',
        'Aplicații: 20+ (Photoshop, Illustrator, Premiere Pro, etc.)',
        'Arhitectura: x64',
        'Mod comercializare: Cod de activare',
        'Utilizatori: 1',
        'Durata licență: 1 An',
        'Tip licențiere: Retail',
        'Limbă: Română/Engleză',
        'Cloud storage: 100GB',
        'Fonturi: Adobe Fonts (mii de fonturi)',
        'Actualizări: Permanente',
        'Platforme: Desktop, Web, Mobile'
    ]
);

CREATE TABLE IF NOT EXISTS seturi (
    id SERIAL PRIMARY KEY,
    nume_set VARCHAR(100) UNIQUE NOT NULL,
    descriere_set TEXT
);

CREATE TABLE IF NOT EXISTS asociere_set (
    id SERIAL PRIMARY KEY,
    id_set INTEGER REFERENCES seturi(id) ON DELETE CASCADE,
    id_produs INTEGER REFERENCES produse(id) ON DELETE CASCADE,
    UNIQUE(id_set, id_produs)
);

INSERT INTO seturi (nume_set, descriere_set) VALUES
('Gaming Beast RTX 5090', 'Configurația supremă pentru gaming 8K și ray-tracing avansat. Include cel mai puternic procesor Intel și placa video RTX 5090 pentru performanțe fără compromisuri.'),
('Mid-Range Gaming Rig', 'Sistemul perfect pentru gaming 1440p fluid. Combinația ideală între performanță și preț pentru majoritatea jocurilor moderne la setări înalte.'),
('Budget Gaming Setup', 'Kit complet de gaming entry-level cu raport calitate-preț excelent. Perfect pentru începători care vor să intre în lumea gaming-ului PC fără să spargă banca.'),
('Productivity Workstation', 'Configurația perfectă pentru creatori de conținut și profesioniști. Procesor multi-core puternic, RAM abundent și stocare rapidă pentru workflow-uri intensive.'),
('Silent Office Build', 'Sistemul ideal pentru birou - silențios, eficient și fiabil. Optimizat pentru productivitate și multitasking fără zgomot deranjant.'),
('RGB Gaming Battlestation', 'Setup-ul complet pentru entuziaștii RGB cu toate componentele sincronizate. Performanță ridicată cu iluminare spectaculoasă pentru experiența gaming ultimă.'),
('Compact Mini-ITX Power', 'Putere maximă într-un format compact. Perfect pentru spații reduse fără compromisuri de performanță - ideal pentru dormitor sau apartamente mici.');

INSERT INTO asociere_set (id_set, id_produs) VALUES
(1, 14), -- Core i9-14900K
(1, 22), -- ROG MAXIMUS Z790 HERO  
(1, 26), -- GeForce RTX 5090
(1, 34), -- Dominator Platinum RGB 32GB DDR5 7200MHz
(1, 36), -- Samsung 980 PRO 2TB
(1, 42), -- ROG Thor 1200P2
(1, 47), -- PC-O11 Dynamic Evo
(1, 53); -- Kraken Z73 RGB

INSERT INTO asociere_set (id_set, id_produs) VALUES
(2, 12), -- Core i5-14600K
(2, 24), -- MAG B760 TOMAHAWK WIFI
(2, 29), -- GeForce RTX 4070 Ti SUPER
(2, 32), -- Fury Beast 32GB DDR5 5200MHz
(2, 37), -- WD SN850X 1TB
(2, 40), -- Pure Power 11 FM 750W
(2, 45), -- 4000D Airflow
(2, 50); -- Pure Rock 2

INSERT INTO asociere_set (id_set, id_produs) VALUES
(3, 10), -- Core i3-14100F
(3, 30), -- GeForce RTX 4060 Ti DUAL OC
(3, 31), -- Fury Beast 32GB DDR4 3200MHz
(3, 38), -- Kingston NV2 1TB
(3, 39), -- System Power 9 600W
(3, 55), -- G413 TKL SE
(3, 58), -- G305 LIGHTSPEED
(3, 62); -- G24F 2

INSERT INTO asociere_set (id_set, id_produs) VALUES
(4, 19), -- Ryzen 9 7950X
(4, 20), -- ROG CROSSHAIR X670E HERO
(4, 33), -- Ripjaws S5 32GB DDR5 6000MHz
(4, 36), -- Samsung 980 PRO 2TB
(4, 40), -- Seagate Barracuda 4TB
(4, 41), -- RM850x (2023)
(4, 46), -- H7 Flow
(4, 51), -- Dark Rock Pro 4
(4, 67); -- MX Master 3S

INSERT INTO asociere_set (id_set, id_produs) VALUES
(5, 11), -- Core i5-13400F  
(5, 31), -- Fury Beast 32GB DDR4 3200MHz
(5, 39), -- Samsung 870 EVO 1TB SATA
(5, 41), -- System Power 9 600W (ID corect)
(5, 50), -- Pure Rock 2
(5, 58), -- MX Keys S
(5, 66), -- M110 Silent
(5, 61); -- V24i-10

INSERT INTO asociere_set (id_set, id_produs) VALUES
(6, 13), -- Core i7-14700K
(6, 23), -- MEG Z790 ACE
(6, 28), -- GeForce RTX 5080 GAMING X TRIO
(6, 34), -- Dominator Platinum RGB 32GB DDR5 7200MHz
(6, 36), -- Samsung 980 PRO 2TB
(6, 42), -- ROG Thor 1200P2
(6, 47), -- PC-O11 Dynamic Evo
(6, 52), -- Kraken X53 RGB
(6, 57), -- ROG Azoth
(6, 60), -- Viper V2 Pro
(6, 74); -- MM700 RGB

INSERT INTO asociere_set (id_set, id_produs) VALUES
(7, 16), -- Ryzen 7 7700X
(7, 30), -- GeForce RTX 4060 Ti DUAL OC
(7, 32), -- Fury Beast 32GB DDR5 5200MHz
(7, 37), -- WD SN850X 1TB
(7, 40), -- Pure Power 11 FM 750W
(7, 48), -- NR200P
(7, 50), -- Pure Rock 2
(7, 55); -- G413 TKL SE