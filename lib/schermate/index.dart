import 'package:app_5ij/schermate/Camerawesome.dart';
import 'package:app_5ij/schermate/Galleria.dart';
import 'package:app_5ij/schermate/Home.dart';
import 'package:app_5ij/schermate/Impostazioni.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _paginaSelezionata = 0;

  final List<Widget> _pagine = [
    const Home(),
    const CameraPage(),
    const Galleria(),
    const Impostazioni()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("App 5I"),
        actions: [
           IconButton(
              onPressed: () => print("Hai premuto il pulsante send"),
              icon: const Icon(Icons.edit_document)),
          IconButton(
              onPressed: () => print("Hai premuto il pulsante search"),
              icon: const Icon(Icons.search))
        ],
      ),
      body: _pagine[_paginaSelezionata],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.photo_camera, color: Colors.white),
          Icon(Icons.list, color: Colors.white),
          Icon(Icons.settings, color: Colors.white),
        ],
        onTap: (index){
          setState(() {
            _paginaSelezionata = index;
          });
          print("Pagina: ${index}");
        },
      ),

    );
  }
}
