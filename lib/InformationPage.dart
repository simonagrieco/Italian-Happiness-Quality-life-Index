import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informazioni del progetto'),
      ),
      body: Row(
        children: [
          Container(
              height: 200,
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
              child: Text("Info")
          ),
        ],
      ),
    );
  }
}
