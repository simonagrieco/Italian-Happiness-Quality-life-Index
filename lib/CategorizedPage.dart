import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategorizedPage extends StatelessWidget {
  List<String> indici = [
    "Assegni sociali",
    "Assorbimento del settore residenziale",
    "Banda larga",
    "Bar",
    "Biblioteche",
    "Calmanti e sonniferi",
    "Cancellazioni anagrafiche",
    "Canoni medi di locazione",
    "Casi Covid-19",
    "Cessazioni di imprese",
    "Cie erogate",
    "Cig ordinaria autorizzata",
    "Cinema",
    "Consumo di farmaci per asma e Bpco",
    "Consumo di farmaci per diabete",
    "Consumo di farmaci per ipertensione",
    "Consumo di farmaci per la depressione",
    "Densità abitativa",
    "Depositi bancari",
    "Diffusione del reddito di cittadinanza",
    "Durata media delle cause civili",
    "Ecosistema urbano",
    "Estorsioni",
    "Eventi sportivi!",
    "Fatture commerciali ai fornitori oltre i 30 giorni",
    "Fondi europei 2014-2020 per l'Agenda digitale",
    "Fondi europei 2014-2020 per l'ambiente e la prevenzione dei rischi",
    "Fondi europei 2014-2020 per l'attrazione culturale, naturale e turistica",
    "Furti",
    "Furti in abitazione",
    "Furti in esercizi commerciali",
    "Gap occupazionale tra maschi e femmine",
    "Giovani che non lavorano e non studiano (Neet)",
    "Il trend del Pil pro capite",
    "Imprenditorialità giovanile",
    "Imprese che fanno ecommerce",
    "Imprese femminili",
    "Imprese in fallimento",
    "Imprese in rete",
    "Imprese straniere",
    "Incendi",
    "Incidenti stradali",
    "Indice di criminalità - totale dei delitti denunciati",
    "Indice di lettura dei quotidiani",
    "Indice di litigiosità",
    "Indice di Rischio Climatico (CRI)",
    "Indice di rotazione delle cause",
    "Indice di vecchiaia",
    "Indice trasormazione digitale",
    "Infermieri",
    "Internet ≥ 100 Mbit/s - abbonamenti",
    "Iscrizioni anagrafiche",
    "Librerie",
    "Medici di medicina generale",
    "Nuove iscrizioni di imprese",
    "Nuovi mutui per l'acquisto di abitazioni",
    "Offerta culturale",
    "Omicidi da incidente stradale",
    "Pago Pa - enti attivi",
    "Palestre ogni 100mila abitanti",
    "Partecipazione alla formazione continua",
    "Partecipazione elettorale",
    "Pediatri",
    "Pensioni di vecchiaia (settore privato)",
    "Persone con almeno il diploma",
    "Piscine",
    "Popolazione con crediti attivi",
    "Pos attivi",
    "Prezzo medio di vendita delle case",
    "Protesti",
    "Quota cause pendenti ultratriennali",
    "Quota di export sul Pil",
    "Rata media mensile",
    "Reddito disponibile",
    "Riciclaggio e impiego di denaro",
    "Riqualificazioni energetiche degli immobili",
    "Ristoranti",
    "Spazio abitativo medio",
    "Spesa delle famiglie",
    "Spesa sociale degli enti locali",
    "Spettacoli - Spesa al botteghino",
    "Spid erogate",
    "Sportività 2020 - \"effetto Covid-19\"",
    "Startup innovative",
    "Tasso di mortalità",
    "Tasso di motorizzazione",
    "Tasso di natalità",
    "Tasso di occupazione",
    "Truffe e frodi informatiche",
    "Violenze sessuali",
    "Imprese che fanno eccomerce"
  ];

  Map<String, List<String>> macroCategorie = {
    'Sicurezza': [],
    'Ambiente': [],
    'Salute': [],
    'Istruzione e cultura': [],
    'Lavoro, guadagni e ricchezza': [],
    'Politica, diritti e cittadinanza': [],
    'Società e comunità': [],
    'Benessere percepito': [],
    'Altro': [], // Aggiungi una macrocategoria per gli indici non assegnati
  };

  List<String> indici_positivi = [
    "Tasso di natalità",
    "Assegni sociali",
    "Assorbimento del settore residenziale",
    "Banda larga",
    "Bar",
    "Biblioteche",
    "Cie erogate",
    "Cinema",
    "Depositi bancari",
    "Diffusione del reddito di cittadinanza",
    "Eventi sportivi",
    "Fondi europei 2014-2020 per l'Agenda digitale",
    "Fondi europei 2014-2020 per l'ambiente e la prevenzione dei rischi",
    "Fondi europei 2014-2020 per l'attrazione culturale, naturale e turistica",
    "Imprenditorialità giovanile",
    "Il trend del Pil pro capite",
    "Imprese che fanno ecommerce",
    "Imprese femminili",
    "Imprese in rete",
    "Imprese straniere",
    "Indice di lettura dei quotidiani",
    "Indice trasormazione digitale",
    "Infermieri",
    "Internet ≥ 100 Mbit/s - abbonamenti",
    "Iscrizioni anagrafiche",
    "Librerie",
    "Medici di medicina generale",
    "Nuove iscrizioni di imprese",
    "Nuovi mutui per l'acquisto di abitazioni",
    "Offerta culturale",
    "Pago Pa - enti attivi",
    "Palestre ogni 100mila abitanti",
    "Partecipazione alla formazione continua",
    "Partecipazione elettorale",
    "Pediatri",
    "Pensioni di vecchiaia (settore privato)",
    "Persone con almeno il diploma",
    "Piscine",
    "Popolazione con crediti attivi",
    "Pos attivi",
    "Reddito disponibile",
    "Riqualificazioni energetiche degli immobili",
    "Ristoranti",
    "Spazio abitativo medio",
    "Spettacoli - Spesa al botteghino",
    "Sportività 2020 - \"effetto Covid-19\"",
    "Startup innovative",
    "Tasso di occupazione",
    "Spesa sociale degli enti locali",
    "Quota di export sul Pil",
    "Ecosistema urbano",
    "Spid erogate"
  ];

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
          ind.contains("Imprenditorialità") ||
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
          ind.contains("Densità") ||
          ind.contains("Partecipazione") ||
          ind.contains("Reddito") ||
          ind.contains("Cittadinanza")) {
        macroCategorie['Politica, diritti e cittadinanza']!.add(ind);
      } else if (ind.contains("Società") ||
          ind.contains("Comunità") ||
          ind.contains("Event") ||
          ind.contains("Spid") ||
          ind.contains("natalità") ||
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

    /*macroCategorie.forEach((categoria, indici) {
      print(categoria);
      print(indici);
      print('------------------------');
    });

    macroCategorie.forEach((categoria, indici) {
      print(categoria);
      print(indici);
      print('------------------------');
    }); */

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
      body: Container(
        child: Stack(
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
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.cancel, color: Colors.red),
                            title: Text("$indice"),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}
