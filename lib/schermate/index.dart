import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'Camera.dart';
import 'Galleria.dart';
import 'Home.dart';
import 'Impostazioni.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _paginaSelezionata = 0;

  final List<Widget> _pagine = [
    const Home(),
    Camera(),
    const Galleria(),
    const Impostazioni()
  ];

  final listaIcone = <IconData>[
    Icons.home,
    Icons.camera,
    Icons.photo_album,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[800],
        title: const Text("Freel 0.90"),
        actions: [
          IconButton(onPressed: () => print("Hai premuto il pulsante EDIT"),
              icon: const Icon(Icons.edit_document)
          ),
          IconButton(onPressed: () => print("Hai premuto il pulsante SEARCH"),
              icon: const Icon(Icons.search)
          ),
        ],
      ),
      body: _pagine[_paginaSelezionata],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.lightBlue[800],
        icons: listaIcone,
        activeColor: Colors.amber,
        inactiveColor: Colors.white70,
        iconSize: 32,
        activeIndex: _paginaSelezionata,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        onTap: (index) => setState(()  => _paginaSelezionata = index),
      ),
    );
    }
}
