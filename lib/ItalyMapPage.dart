import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'HappinessDetailsPage.dart';
import 'dbHelper/mongodb.dart';

class ItalyMapPage extends StatefulWidget {
  @override
  _ItalyMapPageState createState() => _ItalyMapPageState();
}

class _ItalyMapPageState extends State<ItalyMapPage> {
  
  final List<LatLng> cityCoordinates = [
    LatLng(40.8522, 14.2681), // Napoli - Campania
    LatLng(43.6158, 13.5189), // Ancona - Marche
    LatLng(41.5622, 14.6694), // Campobasso - Molise
    LatLng(41.9028, 12.4964), // Roma - Lazio
    LatLng(38.9053, 16.5947), // Catanzaro - Calabria
    LatLng(43.7711, 11.2486), // Firenze - Toscana
    LatLng(39.2238, 9.1217), // Cagliari - Sardegna
    LatLng(45.4342, 12.3388), // Venezia - Veneto
    LatLng(42.3505, 13.3995), // L'Aquila - Abruzzo
    LatLng(38.1157, 13.3613), // Palermo - Sicilia
    LatLng(43.1107, 12.3896), // Perugia - Umbria
    LatLng(40.6395, 15.8050), // Potenza - Basilicata
    LatLng(44.4949, 11.3426), // Bologna - Emilia Romagna
    LatLng(45.6495, 13.7768), // Trieste - Friuli
    LatLng(45.4642, 9.1900), // Milano - Lombardia
    LatLng(44.4056, 8.9463), // Genova - Liguria
    LatLng(41.1177, 16.8512), // Bari - Puglia
    LatLng(45.0703, 7.6869), // Torino - Piemonte
    LatLng(46.0689, 11.1211), // Trento - Trentino

  ];
  List<int> lista_punteggi = [];
  int punteggio = 0;

  late final List<String> regionNames = [];
  late final List<Map<String, dynamic>> regionData = [];

  //late bool isLoading = true;
  bool isDataLoaded = false; // Aggiunta variabile di caricamento iniziale

  @override
  void initState() {
    super.initState();
    connectToMongoDB();
  }

  static var userCollection;

  Future<void> connectToMongoDB() async {
    userCollection = await MongoDatabase.connect();
    final documents = await userCollection.find().toList();
    Map<String, int> punteggiRegioni =
        {}; // Creazione di un dizionario per memorizzare i punteggi delle regioni

    for (final document in documents) {
      final regione = document['DescrRegione'] as String;
      final indicatore = document['Indicatore'] as String;
      final totale = document['Totale'] as double;
      final fascia = document['Fascia'] as int;
      final esito = document['Esito'] as String;
      final macrocategoria = document['Macrocategoria'] as String;
      final unitamisura = document['UnitaMisura'] as String;

      if (!regionNames.contains(regione)) {
        regionNames.add(regione);
      }

      final regionIndex =
          regionData.indexWhere((data) => data['DescrRegione'] == regione);
      if (regionIndex >= 0) {
        regionData[regionIndex]['Indicatore'].add({
          'Indicatore': indicatore,
          'Totale': totale,
          'Fascia': fascia,
          'Esito': esito,
          'Macrocategoria': macrocategoria,
          'UnitaMisura': unitamisura,
        });
      } else {
        regionData.add({
          'DescrRegione': regione,
          'Indicatore': [
            {
              'Indicatore': indicatore,
              'Totale': totale,
            }
          ],
        });
      }

      //CALCOLO PUNTEGGIO
      punteggio = 0; // Inizializza il punteggio per ogni regione
      if ((esito == 'Positivo' && fascia == 3) ||
          (esito == 'Negativo' && fascia == 1)) {
        punteggio += 1; // Incrementa il punteggio di 1
      } else if ((esito == 'Negativo' && fascia == 3) ||
          (esito == 'Positivo' && fascia == 1)) {
        punteggio -= 1; // Decrementa il punteggio di 1
      }
      // Aggiornamento del punteggio della regione corrente nel dizionario punteggiRegioni
      punteggiRegioni.update(regione, (value) => value + punteggio,
          ifAbsent: () => punteggio);

      setState(() {
        //isLoading = false; // Imposta isLoading su false dopo il caricamento dei dati
        isDataLoaded = true;
      });
    }

    // Estrazione dei punteggi dal dizionario e inserimento nella lista_punteggi
    regionNames.forEach((regione) {
      lista_punteggi.add(punteggiRegioni[regione] ?? 0);
    });
    print(lista_punteggi.toString());
    print(regionNames.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (isDataLoaded) {
      List<Marker> markers = [];
      for (int i = 0; i < cityCoordinates.length; i++) {
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: cityCoordinates[i],
            builder: (ctx) => IconButton(
              icon: Image.asset(
                lista_punteggi[i] > 1
                    ? 'assets/felice.png'
                    : (lista_punteggi[i] >= -1) && (lista_punteggi[i] <= 1)
                        ? 'assets/neutro.png'
                        : 'assets/triste.png',
                width: 50,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HappinessDetailsPage(
                      regionData: regionData[i],
                      punteggio: lista_punteggi[i],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Mappa Italia', style: TextStyle()),
              const SizedBox(width: 8), // Aggiungi spazio tra il testo e l'icona
              InkWell(
                onTap: () {
                  // Quando l'utente fa clic sull'icona di informazione, mostra il popup
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Fonte dati'),
                        content: const Text(
                            'https://github.com/IlSole24ORE/QDV2020'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Chiudi il popup
                            },
                            child: const Text('Chiudi'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.info),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: LatLng(41.8719, 12.5674), // Centro dell'Italia
                zoom: 6.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: markers,
                ),
              ],
            ),
            /*if (isLoading) // Indicatore di caricamento circolare condizionale
                const Center(
                  child: CircularProgressIndicator(),
                ),*/
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mappa Italia', style: TextStyle()),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
