import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/immagini/sfondo_base.png"), fit:BoxFit.cover
            ),
          ),
          child: Center(
            child: Image.asset("assets/immagini/logo.png"),
          )
      ),
    );
  }
}