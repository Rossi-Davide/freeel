import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/DBFoto.dart';
import 'Impostazioni.dart';
import 'package:location/location.dart';
import '../model_Manager.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? _controller;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _zoomCorrente = 1.0;
  double _scalaZoom = 1.0;
  int _dita = 0;

  double _lat = -1;
  double _long = -1;

  bool _abilitaFlash = false;
  bool _abilitaGeo = false;

  bool _stop = false;

  final monete = [
    "1 CENTESIMO",
    "2 CENTESIMI",
    "5 CENTESIMI",
    "10 CENTESIMI",
    "20 CENTESIMI",
    "50 CENTESIMI",
    "1 EURO",
    "2 EURO"
  ];

  @override
  void initState() {
    _initializeCamera();

    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_stop) {
        timer.cancel();
      }
      abilitaDisabilitaGeo();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  void _initializeCamera() async {
    CameraDescription description =
        await availableCameras().then((cameras) => cameras[0]);
    _controller = CameraController(description, ResolutionPreset.medium);
    await _controller!.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _takePicture() async {
    String nomeFile = "";

    if (_controller != null) {
      if (_abilitaFlash) {
        await _controller!.setFlashMode(FlashMode.always);
      } else {
        await _controller!.setFlashMode(FlashMode.off);
      }

      await _controller!.takePicture().then((immagine) async {
        nomeFile = basename(immagine.path);
        final docDir = await getApplicationDocumentsDirectory();
        String destinazione = "${docDir.path}/freel";
        String dataCattura = DateFormat.yMd().format(DateTime.now());
        String oraCattura = DateFormat.Hms().format(DateTime.now());

        final esiste = await Directory(destinazione).exists();
        if (!esiste) {
          Directory(destinazione).createSync(recursive: true);
        }
        await File(immagine.path).rename("${destinazione}/${nomeFile}");

        print("Immagine catturata: ${immagine.path}");
        print("Immagine spostata: ${destinazione}/${nomeFile}");

        String nomeCompleto = "${destinazione}/${nomeFile}";

        var stato = await Permission.location.status;
        if (stato.isDenied) {
          stato = await Permission.location.request();
        }

        // if (stato.isDenied) {
        //   _lat = _long = -1;
        // } else {
        //   var posizione = await getLocation();
        //   _lat = posizione.latitude!;
        //   _long = posizione.longitude!;
        // }

        // VALORI PROVVISORI IN ATTESA DEI MODULI SPECIFICI
        GetPrediction get = GetPrediction(valoreMoneta, nomeCompleto);
        double _risultato = -1;
        double _misura = -1;

        final int ris = await DBFoto.creaFoto(nomeCompleto, destinazione,
            _risultato, _misura, _lat, _long, dataCattura, oraCattura);
        if (ris > 0) {
          print("Inserimento nel database effettuato");
        } else {
          print("Inserimento nel database non effettuato");
        }
      });
    }
  }

  void abilitaDisabilitaFlash() async {
    _abilitaFlash = !_abilitaFlash;
    if (_abilitaFlash) {
      await _controller!.setFlashMode(FlashMode.always);
      setState(() {
        _abilitaFlash:
        true;
        flashMode:
        FlashMode.always;
      });
    } else {
      await _controller!.setFlashMode(FlashMode.off);
      setState(() {
        _abilitaFlash:
        false;
        flashMode:
        FlashMode.off;
      });
    }
  }

  void abilitaDisabilitaGeo() async {
    var stato = await Permission.locationWhenInUse.status;
    if (stato.isGranted) {
      _abilitaGeo = true;
    } else {
      _abilitaGeo = false;
    }
    // var stato = await getPermissionStatus();
    // if (stato == PermissionStatus.denied)
    //   this._abilitaGeo = false;
    // else
    //   this._abilitaGeo = true;
  }

  void controllaAbilitazioneGeo() async {
    // var stato = await getPermissionStatus();
    // if (stato == PermissionStatus.denied) {
    //   stato = await requestPermission();
    //   if (stato != PermissionStatus.denied) {
    //     var posizione = await getLocation();
    //     double? latitudine = posizione.latitude;
    //     double? longitudine = posizione.longitude;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Container();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: CameraPreview(_controller!),
        ),
      ),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            Column(
              children: [
                const Spacer(),
                Row(children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      abilitaDisabilitaFlash();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      fixedSize: const Size(50, 50),
                      padding: const EdgeInsets.all(10.0),
                      shape: const CircleBorder(),
                    ),
                    child: (_abilitaFlash)
                        ? const Icon(Icons.flash_on)
                        : const Icon(Icons.flash_off),
                  ),
                  const Spacer(flex: 3),
                  Text(
                    monete[valoreMoneta],
                    style: const TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const Spacer(flex: 3),
                  ElevatedButton(
                    onPressed: () async {
                      //abilitaDisabilitaGeo();
                      var permesso = await Permission.location.request();
                      if (permesso.isDenied) {
                        var permesso = Permission.location.request();
                      }
                      permesso = await Permission.location.status;
                      print("PERMESSO: -->> ${permesso.isGranted}");
                      print("LIMITED: --->> ${permesso.isLimited}");
                      if (permesso.isGranted) {
                        setState(() {
                          _abilitaGeo:
                          true;
                        });
                      } else {
                        setState(() {
                          _abilitaGeo:
                          false;
                        });
                      }
                      //openAppSettings
                      //);
                      // var stato = getPermissionStatus();
                      // if (stato == PermissionStatus.denied)
                      //   this._abilitaGeo = false;
                      // else
                      //   this._abilitaGeo = true;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      fixedSize: const Size(50, 50),
                      padding: const EdgeInsets.all(10.0),
                      shape: const CircleBorder(),
                    ),
                    child: (_abilitaGeo)
                        ? const Icon(Icons.location_on)
                        : const Icon(Icons.location_off),
                  ),
                  const Spacer(),
                ]),
                const Spacer(
                  flex: 15,
                ),
                Row(
                  children: [
                    const Spacer(flex: 5),
                    ElevatedButton(
                      onPressed: () {
                        _takePicture();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        fixedSize: const Size(100, 100),
                        padding: const EdgeInsets.all(10.0),
                        shape: const CircleBorder(),
                      ),
                      child: Image.asset("assets/immagini/logo_freel.png"),
                    ),
                    const Spacer(flex: 5),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
    );
  }
}
