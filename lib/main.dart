import 'package:flutter/material.dart';
import 'TabbarPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Happiness Index - Italy',
      initialRoute: "/",
      home: Tabbar(),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.dark,
        canvasColor: const Color.fromARGB(255, 37, 37, 37),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  var title;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
