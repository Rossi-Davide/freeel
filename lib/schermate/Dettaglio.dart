import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

class Dettaglio extends StatelessWidget {
  final List<Map<String, dynamic>> _foto;
  final int index;

  Dettaglio(this.index, this._foto);

  @override
  Widget build(BuildContext context) {
    final listaIcone = <IconData>[
      Icons.home,
      Icons.camera,
      Icons.photo_album,
      Icons.settings,
    ];

    String path = _foto[index]['nome'];
    Image image = Image.file(File(path));
    String nome = path.substring(path.indexOf('freel/') + 6);

    int risultato = _foto[index]['risultato'];
    String outputRisultato = ' ';
    if (risultato == -1) {
      outputRisultato = 'Migrante';
    } else if (risultato == 1) {
      outputRisultato = 'Non Migrante';
    } else if (risultato == 0) {
      outputRisultato = 'Pre Migrante';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio'),
        backgroundColor: Colors.lightBlue[800],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/immagini/sfondo_02.png"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                "Anguilla #" + _foto[index]['id'].toString(),
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              Text(nome,
                  style: TextStyle(fontSize: 15), textAlign: TextAlign.center),
              SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: Image(
                  image: image.image,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Risultato",
                style: const TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              Text(
                outputRisultato +
                    " [" +
                    _foto[index]['misura'].toStringAsFixed(4) +
                    "]",
                style: outputRisultato == 'Migrante'
                    ? const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)
                    : outputRisultato == 'Non Migrante'
                        ? TextStyle(fontSize: 15, color: Colors.red)
                        : TextStyle(fontSize: 15, color: Colors.orange),
              ),
              SizedBox(height: 10),
              Text(
                "Coordinate",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              Text(
                _foto[index]['latitudine'].toString() +
                    "  " +
                    _foto[index]['longitudine'].toString(),
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 10),
              Text(
                "Data e Ora Cattura",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              Text(
                _foto[index]['oraCattura'].toString() +
                    "  " +
                    _foto[index]['dataCattura'].toString(),
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
          backgroundColor: Colors.lightBlue[800],
          icons: listaIcone,
          activeColor: Colors.amber,
          inactiveColor: Colors.white70,
          iconSize: 32,
          activeIndex: 2,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 0,
          rightCornerRadius: 0,
          onTap: (index) => index),
    );
  }
}
