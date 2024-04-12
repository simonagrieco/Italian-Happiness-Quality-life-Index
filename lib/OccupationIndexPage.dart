import 'package:flutter/material.dart';

class OccupationIndexPage extends StatefulWidget {
  const OccupationIndexPage({Key? key}) : super(key: key);

  @override
  State<OccupationIndexPage> createState() => _OccupationIndexPageState();
}

class _OccupationIndexPageState extends State<OccupationIndexPage> {
  bool checkbox1Value = false;
  bool checkbox2Value = false;
  int selectedRadioValue = 0;

  final List<String> listFasce = [
    "Nessuna scelta",
    "Tutte le scelte",
    "F 15-24",
    "F 25-34",
    "F 35-49",
    "F 50-74",
    "M 15-24",
    "M 25-34",
    "M 35-49",
    "M 50-74"
  ];

  final List<String> titoli1 = [
    "Attività commerciali",
    "Distruzione della popolazione",
    "Attività commerciali - Distruzione della popolazione",
    "Nessuna scelta",
  ];

  final List<String> titoli2 = [
    "Nessuna scelta",
    "Overlay Tasso di disoccupazione italiano",
    "Tasso disoccupazione Femminile 15-24 anni",
    "Tasso disoccupazione Femminile 25-34 anni",
    "Tasso disoccupazione Femminile 35-49 anni",
    "Tasso disoccupazione Femminile 50-74 anni",
    "Tasso disoccupazione Maschile 15-24 anni",
    "Tasso disoccupazione Maschile 25-34 anni",
    "Tasso disoccupazione Maschile 35-49 anni",
    "Tasso disoccupazione Maschile 50-74 anni"
  ];

  // Aggiunto: elenco delle immagini da mostrare
  final List<String> images = [
    'assets/mappe_concentrazione/attivita_lavorative.png',
    'assets/mappe_concentrazione/distribuzione_popolazione.png',
    'assets/mappe_concentrazione/overlay_popolazione_attivita.png',
    'assets/mappe_concentrazione/nulla.png',
  ];

  final List<String> images_maps = [
    'assets/mappe_concentrazione/nulla.png',
    'assets/mappe_concentrazione/tutto.png',
    'assets/mappe_concentrazione/TD_F1524.png',
    'assets/mappe_concentrazione/TD_F2534.png',
    'assets/mappe_concentrazione/TD_F3549.png',
    'assets/mappe_concentrazione/TD_F5074.png',
    'assets/mappe_concentrazione/TD_M1524.png',
    'assets/mappe_concentrazione/TD_M2534.png',
    'assets/mappe_concentrazione/TD_M3549.png',
    'assets/mappe_concentrazione/TD_M5074.png',
  ];

  // Metodo per determinare quale immagine mostrare
  String getImagePath() {
    if (checkbox1Value && checkbox2Value) {
      return images[2]; // Entrambi i checkbox selezionati
    } else if (checkbox1Value) {
      return images[0]; // Solo il primo checkbox selezionato
    } else if (checkbox2Value) {
      return images[1]; // Solo il secondo checkbox selezionato
    } else {
      return images[3]; // Nessun checkbox selezionato
    }
  }

  // Metodo per ottenere il percorso dell'immagine in base al radio button selezionato
  String getImagePathByRadioValue(int radioValue) {
    return images_maps[radioValue];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Tasso di disoccupazione', style: TextStyle()),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Fonte dati'),
                      content: const Text('ISTAT'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Chiudi'),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ExpansionTile(
                      title: const Text(
                        'Scegli il sesso e la fascia d\'età ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Column(
                          children: List.generate(
                            listFasce.length,
                                (index) => RadioListTile(
                              title: Text(listFasce[index]),
                              value: index,
                              groupValue: selectedRadioValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedRadioValue = value as int;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Aggiunto: Testo sopra l'immagine del radio button
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          titoli2[selectedRadioValue],
                          style: const TextStyle(color: Colors.blueAccent),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Aggiunto: Visualizza l'immagine corrispondente al radio button selezionato
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: 350,
                        height: 350,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: InteractiveViewer(
                                    child: Image.asset(
                                      getImagePathByRadioValue(selectedRadioValue),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            getImagePathByRadioValue(selectedRadioValue),
                            width: 350,
                            height: 350,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '    Confronta il tasso di disoccupazione',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Aggiunto: Testo sopra l'immagine del checkbox
                    CheckboxListTile(
                      title: const Text('Attività commerciali'),
                      value: checkbox1Value,
                      onChanged: (value) {
                        setState(() {
                          checkbox1Value = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Distribuzione della popolazione'),
                      value: checkbox2Value,
                      onChanged: (value) {
                        setState(() {
                          checkbox2Value = value!;
                        });
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        checkbox1Value && checkbox2Value
                            ? titoli1[2] // Utilizza il terzo elemento quando entrambi i checkbox sono selezionati
                            : checkbox1Value
                            ? titoli1[0]
                            : checkbox2Value
                            ? titoli1[1]
                            : titoli1.last,
                        style: const TextStyle(color: Colors.blueAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Aggiunto: Mostra l'immagine tra i checkbox e i radiobutton
                    Image.asset(
                      getImagePath(),
                      width: 350,
                      height: 350,
                    ),

                    const SizedBox(height: 20,),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
