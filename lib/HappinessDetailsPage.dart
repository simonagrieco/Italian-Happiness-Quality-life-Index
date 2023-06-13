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
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade200,
                    Colors.grey.shade300,
                  ],
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        "   $regionName  ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 26,
                        ),
                      ),
                      if (punteggio > 0)
                        Row(
                          children: [
                            Text(
                              'Punti: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey.shade500),
                            ),
                            Text(
                              '$punteggio',
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Text(
                              'Punti: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey.shade500),
                            ),
                            Text(
                              '$punteggio',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
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
                    subtitle: Row(
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
                        /*if (indicator['Esito'] == null)
                          Text("Negativo",
                              style: TextStyle(color: Colors.grey.shade400))
                        else*/
                        Text('${indicator['Esito']}',
                            style: TextStyle(color: Colors.grey.shade400)),
                      ],
                    )),
                const Divider()
              ],
            )
        ],
      ),
    );
  }

  int calcolaPunteggio(List<Map<String, dynamic>> indicators){
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