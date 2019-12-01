# osm-civici-cuneo

Utility di confronto per l'elenco vie e numeri civici messo a disposizione dal comune di Cuneo e dati su OSM.

# requirements

- File "Elenco_Vie_Numeri_Civici_Comune_Cuneo_Aggiornato_31_ottobre_2018.xlsx" prelevato da:

http://www.comune.cuneo.it/segreteria-generale-e-servizi-demografici/toponomastica/stradario-comunale.html

da salvare come CSV (senza intestazioni).

- File "OSM_CIVICI_CUNEO.csv" ricavato eseguendo la query su overpass-turbo:

Vecchia Query:
~~[out:csv (::id, ::lat, ::lon, "addr:housenumber", "addr:street")];
{{geocodeArea:cuneo}}->.searchArea;
(
  node["addr:housenumber"][!name](area.searchArea);
);
out body;
>;
out skel qt;~~

```
[out:csv (::id, ::lat, ::lon, "addr:housenumber", "addr:street")];
( area[name=Cuneo][admin_level=8]; )->.searchArea;
(
  node["addr:housenumber"][!name](area.searchArea);
);
out body;
>;
out skel qt;
```

salvare come CSV e rimuovere le intestazioni.

# run

```
$ chmod +x ./confronta.sh
$ ./confronta.sh
```

# TODO

- gestire interpolazioni di indirizzi
- verifica che i civici si trovino nel quartiere giusto (boundary)
