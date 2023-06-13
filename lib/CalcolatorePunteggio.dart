import 'package:mongo_dart/mongo_dart.dart';

import 'dbHelper/mongodb.dart';

class CalcolatorePunteggio {
  final Db database;

  CalcolatorePunteggio(this.database);

  static var userCollection;

  Future<Map<String, int>> calcolaPunteggiPerRegione() async {
    var punteggiPerRegione = <String, int>{};

    userCollection = await MongoDatabase.connect();
    final cursor = await userCollection.find().toList();

    await cursor.forEach((document) {
      final esito = document['Esito'];
      final fascia = document['Fascia'];
      final descrRegione = document['DescrRegione'];

      var punteggio = punteggiPerRegione[descrRegione] ?? 0;

      if ((esito == 'Positivo' && fascia == 3) ||
          (esito == 'Negativo' && fascia == 1)) {
        punteggio += 1;
      }

      if ((esito == 'Negativo' && fascia == 3) ||
          (esito == 'Positivo' && fascia == 1)) {
        punteggio -= 1;
      }

      punteggiPerRegione[descrRegione] = punteggio;
    });

    return punteggiPerRegione;
  }
}
