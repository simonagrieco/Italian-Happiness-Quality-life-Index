import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:italian_happiness_index/TopLowRegionIndexPage.dart';
import 'package:italian_happiness_index/dbHelper/mongodb.dart';

class CategoryIndex extends StatefulWidget {
  @override
  _CategoryIndexState createState() => _CategoryIndexState();
}

class _CategoryIndexState extends State<CategoryIndex> {
  List<String> indici = [];
  List<String> indici_positivi = [];
  Map<String, List<String>> lista_macrocategorie = {};

  late bool isLoading = true; // Aggiunta variabile di caricamento
  late String selectedMacrocategoria;

  /*Map<String, List<String>> macroCategorie = {
    'Sicurezza': [],
    'Ambiente': [],
    'Salute': [],
    'Istruzione e cultura': [],
    'Lavoro, guadagni e ricchezza': [],
    'Politica, diritti e cittadinanza': [],
    'Società e comunità': [],
    'Benessere percepito': [],
    'Altro': [],
  }; */

  @override
  void initState() {
    super.initState();
    connectToMongoDB();
  }

  static var collection;

  void connectToMongoDB() async {
    collection = await MongoDatabase.connect();
    final documents = await collection.find().toList();

    for (final document in documents) {
      final indicatore = document['Indicatore'] as String;
      final esito = document['Esito'] as String;
      final macrocategoria = document['Macrocategoria'] as String;

      if (!indici.contains(indicatore)) {
        indici.add(indicatore);
      }

      if (esito == 'Positivo' && !indici_positivi.contains(indicatore)) {
        indici_positivi.add(indicatore);
      }

      if (!lista_macrocategorie.containsKey(macrocategoria)) {
        lista_macrocategorie[macrocategoria] = [];
      }

      if (!lista_macrocategorie[macrocategoria]!.contains(indicatore)) {
        lista_macrocategorie[macrocategoria]!.add(indicatore);
      } // Aggiungi l'indicatore alla categoria corrispondente
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<IconData> icone = [
      Icons.security_rounded,
      Icons.work,
      Icons.people_alt_rounded,
      Icons.home_filled,
      Icons.accessibility,
      Icons.accessible,
      Icons.onetwothree_sharp,
      Icons.account_balance,
      Icons.account_box,
      Icons.account_box,
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        title: Container(
          child: const Column(
            children: [
              Text('Categorie degli indici'),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Indici positivi ",
                    style: TextStyle(fontSize: 15),
                  ),
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Indici negativi ",
                    style: TextStyle(fontSize: 15),
                  ),
                  Icon(Icons.cancel, color: Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
      body: AbsorbPointer(
        absorbing: isLoading,
        child: Stack(
          children: [
            ListView.builder(
              itemCount: lista_macrocategorie.length,
              itemBuilder: (BuildContext context, int index) {
                String categoria = lista_macrocategorie.keys.elementAt(index);
                List<String> indiciCategoria = lista_macrocategorie[categoria]!;
                return ExpansionTile(
                  title: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedMacrocategoria = categoria;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TopLowIndexPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.info,
                          color: Colors.blueAccent,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 20,),
                      Icon(icone[index % icone.length]),
                      Text(
                        "  " + categoria,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  children: indiciCategoria.map((indice) {
                    bool isPositive = indici_positivi.contains(indice);
                    return ListTile(
                      leading: isPositive
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.cancel, color: Colors.red),
                      title: Text("$indice"),
                    );
                  }).toList(),
                );
              },
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
