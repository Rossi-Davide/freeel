import 'package:flutter/material.dart';

class Impostazioni extends StatefulWidget {
  const Impostazioni({Key? key}) : super(key: key);

  @override
  State<Impostazioni> createState() => _ImpostazioniState();
}

class _ImpostazioniState extends State<Impostazioni> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: const Center(
            child: Text("Impostazioni Page",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 40
                )
            )
        )
    );
  }
}
