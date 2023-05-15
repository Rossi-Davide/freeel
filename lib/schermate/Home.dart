import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/immagini/sfondo_02.png"),
                  fit: BoxFit.cover),
            ),
            child: Column(children: [
              Center(
                child: Image.asset('assets/immagini/freel.png'),
              ),
              const Spacer(flex: 2),
            ])));
  }
}
