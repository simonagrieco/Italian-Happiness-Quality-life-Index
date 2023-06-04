import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:italian_happiness_index/dbHelper/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class CategotyIndex extends StatefulWidget {
  @override
  _CategotyIndexState createState() => _CategotyIndexState();
}

class _CategotyIndexState extends State<CategotyIndex> {
  List<String> indici = [];
  List<String> indici_positivi = [];
  Map<String, List<String>> macroCategorie = {
    'Sicurezza': [],
    'Ambiente': [],
    'Salute': [],
    'Istruzione e cultura': [],
    'Lavoro, guadagni e ricchezza': [],
    'Politica, diritti e cittadinanza': [],
    'Società e comunità': [],
    'Benessere percepito': [],
    'Altro': [],
  };

  @override
  void initState() {
    super.initState();
    connectToMongoDB();
  }

  static var collection;
  void connectToMongoDB() async {

    collection = await MongoDatabase.connect();
    final documents = await collection.find().toList();

    //await db.close();
    for (final document in documents) {
      final indicatore = document['Indicatore'] as String;
      final esito = document['Esito'] as String;

      if (!indici.contains(indicatore)) {
        indici.add(indicatore);
      }

      if (esito == 'Positivo' && !indici_positivi.contains(indicatore)) {
        indici_positivi.add(indicatore);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    for (String ind in indici) {
      if (ind.contains("Furti") ||
          ind.contains("Estorsioni") ||
          ind.contains("Truff") ||
          ind.contains("criminal") ||
          ind.contains("Omicidi") ||
          ind.contains("cause") ||
          ind.contains("Incidenti") ||
          ind.contains("Incendi") ||
          ind.contains("litig") ||
          ind.contains("Violenz")) {
        macroCategorie['Sicurezza']!.add(ind);
      } else if (ind.contains("Ambiente") ||
          ind.contains("Climatico") ||
          ind.contains("Ecosistema") ||
          ind.contains("Riqualificazioni") ||
          ind.contains("Riciclaggio") ||
          ind.contains("motorizzazione") ||
          ind.contains("Energetico")) {
        macroCategorie['Ambiente']!.add(ind);
      } else if (ind.contains("Farmaco") ||
          ind.contains("Salute") ||
          ind.contains("Consumo") ||
          ind.contains("Calmanti") ||
          ind.contains("Mortalità") ||
          ind.contains("Pediatri") ||
          ind.contains("Medici") ||
          ind.contains("vecchiaia") ||
          ind.contains("Covid") ||
          ind.contains("Infermieri") ||
          ind.contains("morta") ||
          ind.contains("Violenza sessuale")) {
        macroCategorie['Salute']!.add(ind);
      } else if (ind.contains("Istruzione") ||
          ind.contains("ultura") ||
          ind.contains("Biblioteca") ||
          ind.contains("diploma") ||
          ind.contains("lettura") ||
          ind.contains("Teatro")) {
        macroCategorie['Istruzione e cultura']!.add(ind);
      } else if (ind.contains("Imprese") ||
          ind.contains("imprese") ||
          ind.contains("Cig") ||
          ind.contains("Reddito") ||
          ind.contains("Giovani") ||
          ind.contains("Fatture") ||
          ind.contains("Imprenditorialita'") ||
          ind.contains("Pil") ||
          ind.contains("Assegni") ||
          ind.contains("crediti") ||
          ind.contains("occupazione") ||
          ind.contains("Soldi") ||
          ind.contains("Spesa") ||
          ind.contains("Prezzo") ||
          ind.contains("Fondi") ||
          ind.contains("banca") ||
          ind.contains("Startup") ||
          ind.contains("Pos") ||
          ind.contains("Imprese") ||
          ind.contains("reddito") ||
          ind.contains("mutui") ||
          ind.contains("Gap") ||
          ind.contains("Pago") ||
          ind.contains("Economia")) {
        macroCategorie['Lavoro, guadagni e ricchezza']!.add(ind);
      } else if (ind.contains("Politica") ||
          ind.contains("Diritti") ||
          ind.contains("Densita'") ||
          ind.contains("Partecipazione") ||
          ind.contains("Reddito") ||
          ind.contains("Cittadinanza")) {
        macroCategorie['Politica, diritti e cittadinanza']!.add(ind);
      } else if (ind.contains("Società") ||
          ind.contains("Comunità") ||
          ind.contains("Event") ||
          ind.contains("Spid") ||
          ind.contains("natalita'") ||
          ind.contains("Cie") ||
          ind.contains("Associazione")) {
        macroCategorie['Società e comunità']!.add(ind);
      } else if (ind.contains("Benessere") ||
          ind.contains("Spesa famiglie") ||
          ind.contains("Banda") ||
          ind.contains("Assorbimento") ||
          ind.contains("Locazione") ||
          ind.contains("Canoni") ||
          ind.contains("Cinema") ||
          ind.contains("Bar") ||
          ind.contains("Biblioteche") ||
          ind.contains("Piscine") ||
          ind.contains("Librerie") ||
          ind.contains("Ristoranti") ||
          ind.contains("Internet") ||
          ind.contains("bitativo") ||
          ind.contains("Palestre") ||
          ind.contains("Rata") ||
          ind.contains("digitale") ||
          ind.contains("Partecipazione elettorale")) {
        macroCategorie['Benessere percepito']!.add(ind);
      } else {
        macroCategorie['Altro']!.add(ind);
      }
    }


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
      body: Stack(
        children: [
          ListView.builder(
            itemCount: macroCategorie.length,
            itemBuilder: (BuildContext context, int index) {
              String categoria = macroCategorie.keys.elementAt(index);
              List<String> indiciCategoria = macroCategorie[categoria]!;
              return ExpansionTile(
                title: Text(
                  categoria,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: indiciCategoria
                    .map((indice) => ListTile(
                  leading: indici_positivi.contains(indice)
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.cancel, color: Colors.red),
                  title: Text("$indice"),
                ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
