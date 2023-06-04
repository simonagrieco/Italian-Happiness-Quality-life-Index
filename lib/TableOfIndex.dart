import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TableOfIndex extends StatefulWidget {
  TableOfIndex({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _TableOfIndexState createState() => _TableOfIndexState();
}

class _TableOfIndexState extends State<TableOfIndex> {
  List<Qualita> qualitaData = [];
  List<Provincia> provinciaData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String qualitaCsv = await rootBundle.loadString('lib/datasets/20201214_QDV2020_001.csv');
    String provinciaCsv = await rootBundle.loadString('lib/datasets/20201214_QDV2020COVID_001.csv');
    parseQualitaCsv(qualitaCsv);
    parseProvinciaCsv(provinciaCsv);

    // Perform data operations
    qualitaData.forEach((qualita) {
      qualita.INDICATORE = qualita.INDICATORE.toString();
      qualita.UNITA_DI_MISURA = qualita.UNITA_DI_MISURA.toString();
    });

    List<String> qualitaIndicatoreLevels = qualitaData.map((qualita) => qualita.INDICATORE).toSet().toList();
    int colore = 2;

    for (String ind in qualitaIndicatoreLevels) {
      List<String> unita = qualitaData
          .where((qualita) => qualita.INDICATORE == ind)
          .map((qualita) => qualita.UNITA_DI_MISURA)
          .toSet()
          .toList();

      Map<String, List<double>> regionData = {};
      qualitaData.where((qualita) => qualita.INDICATORE == ind).forEach((qualita) {
        if (!regionData.containsKey(qualita.DescrRegione)) {
          regionData[qualita.DescrRegione] = [];
        }
        regionData[qualita.DescrRegione]!.add(qualita.VALORE);
      });

      List<RegionData> regionChartData = regionData.entries.map((entry) {
        String region = entry.key;
        double meanValue = entry.value.reduce((a, b) => a + b) / entry.value.length;
        return RegionData(region, meanValue);
      }).toList();

      regionChartData.sort((a, b) => a.totale.compareTo(b.totale));

      // Create and show the chart
      Chart chart = Chart(regionChartData, unita[0], ind, colore);
      print(chart);

      colore++;
    }
  }

  void parseQualitaCsv(String csvData) {
    List<String> lines = csvData.split('\n');
    qualitaData = lines
        .sublist(1)
        .map((line) => line.split(','))
        .map((cols) => Qualita(cols[0], cols[1], cols[2], double.parse(cols[2]) as double, cols[3] as String))
        .toList();
  }

  void parseProvinciaCsv(String csvData) {
    List<String> lines = csvData.split('\n');
    provinciaData = lines
        .sublist(1)
        .map((line) => line.split(';'))
        .map((cols) => Provincia(cols[2], cols[5]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          'QualitaVita',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class Qualita {
  String DescrProvincia;
  String DescrRegione;
  String INDICATORE;
  double VALORE;
  String UNITA_DI_MISURA;

  Qualita(this.DescrProvincia, this.DescrRegione, this.INDICATORE, this.VALORE, this.UNITA_DI_MISURA);
}

class Provincia {
  String DescrProvincia;
  String DescrRegione;

  Provincia(this.DescrProvincia, this.DescrRegione);
}

class RegionData {
  String DescrRegione;
  double totale;

  RegionData(this.DescrRegione, this.totale);
}

class Chart {
  List<RegionData> data;
  String unita;
  String ind;
  int colore;

  Chart(this.data, this.unita, this.ind, this.colore);

  @override
  String toString() {
    return '''
      Chart: $ind
      Unit: $unita
      Data: $data
      Color: $colore
    ''';
  }
}
