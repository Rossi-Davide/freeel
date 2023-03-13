import 'package:flutter/material.dart';

class Galleria extends StatefulWidget {
  const Galleria({Key? key}) : super(key: key);

  @override
  State<Galleria> createState() => _GalleriaState();
}

class _GalleriaState extends State<Galleria> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: const Center(
            child: Text("Galleria Page",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 40
                )
            )
        )
    );
  }
}

