import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../data/DBFoto.dart';

int valoreMoneta = 3;

class Impostazioni extends StatefulWidget {
  const Impostazioni({Key? key}) : super(key: key);

  @override
  State<Impostazioni> createState() => _ImpostazioniState();
}

class _ImpostazioniState extends State<Impostazioni> {
  risultatoCancellazioneKo() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Risultato cancellazione"),
          content: Text(
              "La cancellazione non si è conclusa correttamente oppure non c'erano foto da cancellare."),
          actions: [
            TextButton(
              child: Text("Chiudi"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  risultatoCancellazioneOk() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Risultato cancellazione"),
          content: Text("La cancellazione si è conclusa correttamente"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  inizializzaTabella() async {
    int risultato = await DBFoto.svuotaTabellaFoto();
    print("RISULTATO CANCELLAZIONE: ${risultato}");
    Navigator.of(context).pop();
    if (risultato > 0) {
      risultatoCancellazioneOk();
    } else
      risultatoCancellazioneKo();
  }

  aggiungiFotoTabella() async {
    await DBFoto.inserisciDatiProva();
    Navigator.of(context).pop();
  }

  confermaCancellazione() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cancellazione tabella"),
          content: Text("Vuoi veramente inizializzare la tabella FOTO?"),
          actions: [
            TextButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("SI"),
              onPressed: () {
                inizializzaTabella();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/immagini/sfondo_02.png"),
              fit: BoxFit.cover),
        ),
        child: SettingsList(
          sections: [
            SettingsSection(
              title: Text('Inizializzazioni'),
              tiles: <SettingsTile>[
                SettingsTile(
                  onPressed: (value) => {
                    confermaCancellazione(),
                  },
                  leading: Image.asset("assets/immagini/icona_del_tabella.png"),
                  title: Text('Inizializza tabella'),
                  description:
                      Text('Rimuove tutte le immagini presenti in elenco'),
                ),
              ],
            ),
            SettingsSection(
              title: Text("Selezione moneta"),
              tiles: <SettingsTile>[
                SettingsTile(
                  leading: Image.asset("assets/immagini/icona_monete.png"),
                  description: Text('Moneta utilizzata per la misurazione'),
                  title: DropdownButton(
                    items: const [
                      DropdownMenuItem(child: Text("1 centesimo"), value: 0),
                      DropdownMenuItem(child: Text("2 centesimi"), value: 1),
                      DropdownMenuItem(child: Text("5 centesimi"), value: 2),
                      DropdownMenuItem(child: Text("10 centesimi"), value: 3),
                      DropdownMenuItem(child: Text("20 centesimi"), value: 4),
                      DropdownMenuItem(child: Text("50 centesimi"), value: 5),
                      DropdownMenuItem(child: Text("1 euro"), value: 6),
                      DropdownMenuItem(child: Text("2 euro"), value: 7),
                    ],
                    isExpanded: true,
                    onChanged: (int? newvalue) {
                      // This is called when the user selects an item.
                      setState(() {
                        valoreMoneta = newvalue!;
                      });
                    },
                    value: valoreMoneta,
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: Text('Invio segnalazioni'),
              tiles: <SettingsTile>[
                SettingsTile(
                  onPressed: (value) => {},
                  leading: Image.asset("assets/immagini/icona_mail.png"),
                  title: Text('Email'),
                  description: Text('Imposta parametri per l' 'invio'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
