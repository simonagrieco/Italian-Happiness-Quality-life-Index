import 'package:flutter/material.dart';

class HappinessDetailsPage extends StatelessWidget {
  final Map<String, dynamic> regionData;
  final int punteggio;

  HappinessDetailsPage({required this.regionData, required this.punteggio});

  //COMPRENDERE PERCHE' NON SI PRENDE IL PRIMO ELEMENTO

  @override
  Widget build(BuildContext context) {

    String regionName = regionData['DescrRegione'];
    List<Map<String, dynamic>> indicators = regionData['Indicatore'];

    //Calcola punteggio
    //int punteggio = 0;
    //punteggio = calcolaPunteggio(indicators);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Dettagli ', style: TextStyle()),
            const SizedBox(width: 8), // Aggiungi spazio tra il testo e l'icona
            InkWell(
              onTap: () {
                // Quando l'utente fa clic sull'icona di informazione, mostra il popup
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Informazioni'),
                      content: const Text(
                          'Il calcolo del punteggio è stato calcolato nel seguente modo: \n\n\n'
                              '+ 1 punto se la regione si è classificata nel primo terzo di tutte le regioni per un indice positivo\n\n'
                              '- 1 punto se la regione si è classificata nell ultimo terzo di tutte le regioni per un indice negativo\n\n'
                              '0 punti se la regione si è classicata esattamente a metà fra tutte le regioni per entrambe le tipologie di indici'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Chiudi il popup
                          },
                          child: Text('Chiudi'),
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
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: Container(
              height: 70,
              width: 200,
              decoration: BoxDecoration(
                color:
                    punteggio > 0 ? Colors.green.shade300 : Colors.red.shade300,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    regionName.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(width: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          punteggio.toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          for (var indicator in indicators)
            Column(
              children: [
                ListTile(
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if ((indicator['Esito'] == "Positivo" &&
                                indicator['Fascia'] == 3) ||
                            (indicator['Esito'] == "Negativo" &&
                                indicator['Fascia'] == 1))
                          /*const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ), */
                          const Text(
                            '+1',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 22),
                          ),
                        if ((indicator['Esito'] == "Negativo" &&
                                indicator['Fascia'] == 3) ||
                            indicator['Esito'] == "Positivo" &&
                                indicator['Fascia'] == 1)
                          /* const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 18,
                          ), */
                          const Text(
                            '-1',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                          ),
                        if ((indicator['Esito'] == "Negativo" ||
                                indicator['Esito'] == "Positivo") &&
                            indicator['Fascia'] == 2)
                          /* const Icon(
                            Icons.circle,
                            color: Colors.grey,
                            size: 18,
                          ), */
                          const Text(
                            '0',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 22),
                          ),
                        Text(
                          '  ${indicator['Indicatore']}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${indicator['Totale']}'),
                      ],
                    ),
                  ),
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  /*if (indicator['Esito'] == 'Positivo')
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          )
                        else
                          const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 18,
                          ),
                        */
                                  Text(
                                    "Tipo di indice: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade500),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('${indicator['Esito']}',
                                      style: TextStyle(color: Colors.grey.shade400)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Macrocategoria: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade500),
                                  ),
                                  Text('${indicator['Macrocategoria']}',
                                      style: TextStyle(color: Colors.grey.shade400)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Unita' di misura: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade500),
                                  ),
                                  Text(
                                    "${indicator['UnitaMisura']}",
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider()
              ],
            )
        ],
      ),
    );
  }

  /*int calcolaPunteggio(List<Map<String, dynamic>> indicators) {
    int punteggio = 0;
    for (var indicator in indicators) {
      if (indicator['Esito'] == 'Positivo' && indicator['Fascia'] == 3) {
        punteggio += 1;
      }
      if (indicator['Esito'] == 'Negativo' && indicator['Fascia'] == 1) {
        punteggio += 1;
      }

      if (indicator['Esito'] == 'Negativo' && indicator['Fascia'] == 3) {
        punteggio -= 1;
      }
      if (indicator['Esito'] == 'Positivo' && indicator['Fascia'] == 1) {
        punteggio -= 1;
      }

      print(punteggio);
    }
    return punteggio;
  } */
}
