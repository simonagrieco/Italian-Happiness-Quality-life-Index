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
    LatLng(42.3505, 13.3995), // L'Aquila - Abruzzo
    LatLng(40.6395, 15.8050), // Potenza - Basilicata
    LatLng(38.9053, 16.5947), // Catanzaro - Calabria
    LatLng(40.8522, 14.2681), // Napoli - Campania
    LatLng(44.4949, 11.3426), // Bologna - Emilia Romagna
    LatLng(45.6495, 13.7768), // Trieste - Friuli
    LatLng(41.9028, 12.4964), // Roma - Lazio
    LatLng(44.4056, 8.9463), // Genova - Liguria
    LatLng(45.4642, 9.1900), // Milano - Lombardia
    LatLng(43.6158, 13.5189), // Ancona - Marche
    LatLng(41.5622, 14.6694), // Campobasso - Molise
    LatLng(45.0703, 7.6869), // Torino - Piemonte
    LatLng(41.1177, 16.8512), // Bari - Puglia
    LatLng(39.2238, 9.1217), // Cagliari - Sardegna
    LatLng(38.1157, 13.3613), // Palermo - Sicilia
    LatLng(43.7711, 11.2486), // Firenze - Toscana
    LatLng(46.0689, 11.1211), // Trento - Trentino
    LatLng(43.1107, 12.3896), // Perugia - Umbria
    LatLng(45.4342, 12.3388), // Venezia - Veneto
  ];

  late final List<String> regionNames = [];
  late final List<Map<String, dynamic>> regionData = [];
  late bool isLoading = true; // Aggiunta variabile di caricamento

  @override
  void initState() {
    super.initState();
    connectToMongoDB();
  }

  static var userCollection;

  Future<void> connectToMongoDB() async {
    userCollection = await MongoDatabase.connect();
    final documents = await userCollection.find().toList();

    for (final document in documents) {
      final regione = document['DescrRegione'] as String;
      final indicatore = document['Indicatore'] as String;
      final totale = document['Totale'] as double;
      final fascia = document['Fascia'] as int;
      final esito = document['Esito'] as String;
      final macrocategoria = document['Macrocategoria'] as String;

      if (!regionNames.contains(regione)) {
        regionNames.add(regione);
      }

      final regionIndex = regionData.indexWhere((data) => data['DescrRegione'] == regione);

      if (regionIndex >= 0) {
        regionData[regionIndex]['Indicatore'].add({
          'Indicatore': indicatore,
          'Totale': totale,
          'Fascia': fascia,
          'Esito': esito,
          'Macrocategoria': macrocategoria,
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

      //calcolo del punteggio
      /*if ((esito == 'Positivo' && fascia == 3) || esito == 'Negativo' && fascia == 1) {
        setState(() {
          punteggio += 1;
        });
      }
      if ((esito == 'Negativo' && fascia == 3) || esito == 'Positivo' && fascia == 1) {
        setState(() {
          punteggio -= 1;
        });
      } */

      setState(() {
        isLoading =
        false; // Imposta isLoading su false dopo il caricamento dei dati
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [];

    for (int i = 0; i < cityCoordinates.length; i++) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: cityCoordinates[i],
          builder: (ctx) => IconButton(
            /*icon: punteggio > 0
                ? const Icon(
              Icons.sentiment_very_satisfied,
              color: Colors.black,
            )
                : const Icon(
              Icons.sentiment_dissatisfied_rounded,
              color: Colors.black,
            ), */
            icon: const Icon(
              Icons.location_on_rounded,
              color: Colors.lightBlue,
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HappinessDetailsPage(
                    regionData: regionData[i],
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
        title: const Align(
          alignment: Alignment.center,
          child: Text('Mappa dell\'Italia', style: TextStyle()),
        ),
      ),
      body: AbsorbPointer(
        absorbing: isLoading,
        child: Stack(
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
            if (isLoading) // Indicatore di caricamento circolare condizionale
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }


}