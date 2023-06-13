import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dbHelper/mongodb.dart';

class ClassificationPage extends StatefulWidget {
  const ClassificationPage({Key? key}) : super(key: key);

  @override
  State<ClassificationPage> createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  late bool isLoading = true; // Aggiunta variabile di caricamento

  @override
  void initState() {
    super.initState();
    connectToMongoDB();
  }

  static var userCollection;
  Map<String, double> sumPositiveMap = {};
  Map<String, double> sumNegativeMap = {};
  List<MapEntry<String, double>> sortedPositiveEntries = [];
  List<MapEntry<String, double>> sortedNegativeEntries = [];

  Future<void> connectToMongoDB() async {
    userCollection = await MongoDatabase.connect();
    final documents = await userCollection.find().toList();

    for (final document in documents) {
      final regione = document['DescrRegione'] as String;
      //final indicatore = document['Indicatore'] as String;
      final totale = document['Totale'] as double;
      final esito = document['Esito'] as String;

      if (esito == "Positivo") {
        sumPositiveMap[regione] = (sumPositiveMap[regione] ?? 0) + totale;
      } else if (esito == "Negativo") {
        sumNegativeMap[regione] = (sumNegativeMap[regione] ?? 0) + totale;
      }

      setState(() {
        isLoading =
            false; // Imposta isLoading su false dopo il caricamento dei dati
      });
      sortedPositiveEntries = sumPositiveMap.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      sortedNegativeEntries = sumNegativeMap.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
    }
  }

  @override
  Widget build(BuildContext context) {
    var i=1;

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Text('Classificazione regioni', style: TextStyle()),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                ExpansionTile(
                  title: const Row(
                    children: [
                       Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 25,
                      ),
                      Text(
                        ' Somma dei totali - Indici positivi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    for (var i = 0; i < sumPositiveMap.keys.length; i++)
                      //for (final regione in sumPositiveMap.keys)
                      ListTile(
                        title: Text(
                          (i +1).toString()+". " + sumPositiveMap.keys.toList()[i], //regione
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Somma: ${sumPositiveMap.values.toList()[i]}', //${sumPositiveMap[regione]
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                  ],
                ),
                ExpansionTile(
                  title: const Row(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 25,
                      ),
                      Text(
                        ' Somma dei totali - Indici negativi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    for (var i = 0; i < sumNegativeMap.keys.length; i++)
                      ListTile(
                        title: Text(
                          (i +1).toString()+". " + sumNegativeMap.keys.toList()[i],//regione,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Somma: ${sumNegativeMap.values.toList()[i]}',//'Somma: ${sumNegativeMap[regione]}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
                if (isLoading) // Indicatore di caricamento circolare condizionale
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}
