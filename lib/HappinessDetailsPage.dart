import 'package:flutter/material.dart';

class HappinessDetailsPage extends StatelessWidget {
  final Map<String, dynamic> regionData;
  int punteggio = 0;

  HappinessDetailsPage({required this.regionData});

  //COMPRENDERE PERCHE' NON SI PRENDE IL PRIMO ELEMENTO

  @override
  Widget build(BuildContext context) {
    String regionName = regionData['DescrRegione'];
    List<Map<String, dynamic>> indicators = regionData['Indicatore'];
    int punteggio = 0;

    //print(indicators['Esito']);

    //Calcola punteggio
    punteggio = calcolaPunteggio(indicators);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli felicità'),
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
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),
                        if ((indicator['Esito'] == "Negativo" &&
                                indicator['Fascia'] == 3) ||
                            indicator['Esito'] == "Positivo" &&
                                indicator['Fascia'] == 1)
                          const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 18,
                          ),
                        if ((indicator['Esito'] == "Negativo" ||
                                indicator['Esito'] == "Positivo") &&
                            indicator['Fascia'] == 2)
                          const Icon(
                            Icons.circle,
                            color: Colors.grey,
                            size: 18,
                          ),
                        Text(
                          '  ${indicator['Indicatore']}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${indicator['Totale']}'),
                      ],
                    ),
                  ),
                  subtitle: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
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
                  ),
                ),
                const Divider()
              ],
            )
        ],
      ),
    );
  }

  int calcolaPunteggio(List<Map<String, dynamic>> indicators) {
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
  }
}
