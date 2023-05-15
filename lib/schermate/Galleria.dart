import '../data/DBFoto.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'Dettaglio.dart';

class Galleria extends StatefulWidget {
  const Galleria({Key? key}) : super(key: key);

  @override
  State<Galleria> createState() => _GalleriaState();
}

class _GalleriaState extends State<Galleria> {
  List<Map<String, dynamic>> _foto = [];
  bool inCaricamento = true;

  double diametroMoneta = -1,
      leftMoneta = -1,
      topMoneta = -1,
      rightMoneta = -1,
      bottomMoneta = -1;
  double leftAnguilla = -1,
      topAnguilla = -1,
      rightAnguilla = -1,
      bottomAnguilla = -1;

  void _aggiornaElencoFoto() async {
    final risultato = await DBFoto.getElencoFoto();
    setState(() {
      _foto = risultato;
      inCaricamento = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _aggiornaElencoFoto();
  }

  // Delete an item
  void cancellaFoto(int id) async {
    await DBFoto.cancellaFoto(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('La foto è stata correttamente cancellata'),
    ));
    _aggiornaElencoFoto();
  }

  void mostraFoto(int? id) async {}

  Widget listTitle(int index) {
    String path = _foto[index]['nome'];
    Image image = Image.file(File(path));

    int risultato = _foto[index]['risultato'];
    String outputRisultato = ' ';

    if (risultato == -1) {
      outputRisultato = 'Migrante';
    } else if (risultato == 1) {
      outputRisultato = 'Non Migrante';
    } else if (risultato == 0) {
      outputRisultato = 'Pre Migrante';
    }

    return Card(
      //color: Colors.orange[200],
      child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          tileColor: Colors.transparent,
          title: Text("Anguilla #" + _foto[index]['id'].toString()),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: image.image,
          ),
          subtitle: Text(
            outputRisultato,
            style: outputRisultato == 'Migrante'
                ? TextStyle(fontSize: 15, color: Colors.green)
                : outputRisultato == 'Non Migrante'
                    ? TextStyle(fontSize: 15, color: Colors.red)
                    : TextStyle(fontSize: 15, color: Colors.orange),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Dettaglio(index, _foto)));
          }),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/immagini/sfondo_02.png"),
              fit: BoxFit.cover),
        ),
        child: Opacity(
          opacity: 0.80,
          child: ListView.builder(
            itemCount: _foto.length,
            itemBuilder: (context, index) => listTitle(index),
          ),
        ),
      ),
    );
  }
}
