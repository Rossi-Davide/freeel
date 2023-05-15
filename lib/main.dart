import 'package:flutter/material.dart';
import 'schermate/Index.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FREEL 0.9",
      theme: ThemeData(
        // Define the default brightness and colors.
        //brightness: Brightness.dark,
        //primaryColor: Colors.black,
        listTileTheme: ListTileThemeData(
          tileColor: Colors.lightBlue[800],
        ),
        // Define the default font family.
        // Roboto è il font più diffuso perché gestito direttamente da Google
        // Occorre verificare se è lo stesso per iOS
        fontFamily: 'Roboto',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        // textTheme: const TextTheme(
        //   displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        //   titleLarge: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal),
        //   bodyMedium: TextStyle(fontSize: 14.0),
        // ),
        //primaryTextTheme: Typography().black,

      ),
      home:  Index(),
    );
  }
}
