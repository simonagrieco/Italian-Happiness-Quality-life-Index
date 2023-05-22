import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ItalyMapPage extends StatelessWidget {

  final List<LatLng> cityCoordinates = [
    LatLng(45.0703, 7.6869), // Torino
    LatLng(45.4642, 9.1900), // Milano
    LatLng(45.4342, 12.3388), // Venezia
    LatLng(45.6495, 13.7768), // Trieste
    LatLng(44.4056, 8.9463), // Genova
    LatLng(44.4949, 11.3426), // Bologna
    LatLng(43.7711, 11.2486), // Firenze
    LatLng(43.6158, 13.5189), // Ancona
    LatLng(41.9028, 12.4964), // Roma
    LatLng(42.3505, 13.3995), // L'Aquila
    LatLng(40.8522, 14.2681), // Napoli
    LatLng(41.1177, 16.8512), // Bari
    LatLng(38.1157, 13.3613), // Palermo
    LatLng(39.2238, 9.1217), // Cagliari
    LatLng(38.9053, 16.5947), // Catanzaro
    LatLng(40.6395, 15.8050), // Potenza
    LatLng(41.5622, 14.6694), // Campobasso
    LatLng(45.7370, 7.3200), // Aosta
    LatLng(43.1107, 12.3896), // Perugia
    LatLng(46.0689, 11.1211), // Trento
    LatLng(45.6495, 13.7768), // Trieste
    LatLng(46.4983, 11.3540), // Bolzano
    LatLng(41.5622, 14.6694), // Campobasso
  ];

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
            icon: Icon(
              Icons.location_on_rounded,
              color: Colors.lightBlue,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Pop-up di esempio'),
                    content: Text('Hai cliccato sul marker di una città.'),
                    actions: [
                      TextButton(
                        child: Text('Chiudi'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Align(
            child: Text('Map of Italy', style: TextStyle()),
            alignment: Alignment.center,
          )
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(41.8719, 12.5674), // Centro dell'Italia
          zoom: 6.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: markers,
          ),
        ],
      ),
    );
  }
}
