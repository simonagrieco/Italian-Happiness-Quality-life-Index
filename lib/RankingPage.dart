import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dbHelper/mongodb.dart';

class ClassificationPage extends StatefulWidget {
  const ClassificationPage({Key? key}) : super(key: key);

  @override
  State<ClassificationPage> createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage>
    with SingleTickerProviderStateMixin {
  late bool isLoading = true; // Aggiunta variabile di caricamento
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    connectToMongoDB();
    _tabController = TabController(length: 2, vsync: this);
  }

  static var userCollection;
  Map<String, double> sumPositiveMap = {};
  Map<String, double> sumNegativeMap = {};

  Future<void> connectToMongoDB() async {
    userCollection = await MongoDatabase.connect();
    final documents = await userCollection.find().toList();

    for (final document in documents) {
      final regione = document['DescrRegione'] as String;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    //Liste per ordinare le somme in maniera descrescente
    List<String> sortedPositiveKeys = sumPositiveMap.keys.toList();
    sortedPositiveKeys
        .sort((a, b) => sumPositiveMap[b]!.compareTo(sumPositiveMap[a]!));

    List<String> sortedNegativeKeys = sumNegativeMap.keys.toList();
    sortedNegativeKeys
        .sort((a, b) => sumNegativeMap[b]!.compareTo(sumNegativeMap[a]!));

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Text('Rank per regione', style: TextStyle()),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Indici positivi',
              icon: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 25,
                shadows: [],
              ),
            ),
            Tab(
              text: 'Indici negativi',
              icon: Icon(Icons.cancel, color: Colors.red, size: 25),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: sortedPositiveKeys.length,
                  itemBuilder: (context, index) {
                    final regione = sortedPositiveKeys[index];
                    final somma = sumPositiveMap[regione]!.toStringAsFixed(3);

                    return ListTile(
                      title: Row(
                        children: [
                          Text(
                            (index + 1).toString() + ". ",
                          ),
                          Text(
                            regione,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Somma: $somma',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: sortedNegativeKeys.length,
                  itemBuilder: (context, index) {
                    final regione = sortedNegativeKeys[index];
                    final somma = sumNegativeMap[regione]!.toStringAsFixed(3);

                    return ListTile(
                      title: Row(
                        children: [
                          Text(
                            (index + 1).toString() + ". ",
                          ),
                          Text(
                            regione,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Somma: $somma',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
