import 'dart:io';
import 'dart:async';
import 'package:better_open_file/better_open_file.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:mutex/mutex.dart';
import '../data/DBFoto.dart';

class GetPrediction {
  static var platform;

  double misurazione = 0;
  int risultato = 0;
  int _index = 0;
  String percorso = "";
  var width = [16.25, 18.75, 21.25, 19.75, 22.25, 24.25, 22.25, 25.75];
  bool dinamica = true;
  String oraFoto = "";
  String dataFoto = "";
  double latitude = 0.0;
  double longitude = 0;
  String nomeFoto = "";

  double midpoint(double y1, double y2) {
    return ((y1 + y2) * 0.5);
  }

/*
  double calculateDistanceInPixels(double x1, double y1, double x2, double y2, double resolution) {
    double deltaX = x2 - x1;
    double deltaY = y2 - y1;

    double distanceInPixels = distance * resolution;
    return distanceInPixels;
  }
*/
  void misura(dynamic widthM, dynamic leftM, dynamic topM, dynamic rightM,
      dynamic botM, dynamic leftA, dynamic topA, dynamic rightA, dynamic botA) {
    double pixelsPerMetric = 0;
    double tltrX = 0,
        tltrY = 0,
        blbrX = 0,
        blbrY = 0,
        tlblX = 0,
        tlblY = 0,
        trbrX = 0,
        trbrY = 0;
    // tltrX = midpoint(leftM, rightM);
    // tltrY = midpoint(topM, topM);
    // blbrX = midpoint(leftM, rightM);
    // blbrY = midpoint(botM, botM);
    // tlblX = midpoint(leftM, leftM);
    // tlblY = midpoint(topM, botM);
    // trbrX = midpoint(rightM, rightM);
    // trbrY = midpoint(topM, botM);
    double distanceX = (rightM - leftM);
    double distanceY = (botM - topM);
    double distanceM = (distanceX + distanceY) / 2;
    pixelsPerMetric = distanceM / widthM;
    double tltrXanguilla = 0,
        tltrYanguilla = 0,
        blbrXanguilla = 0,
        blbrYanguilla = 0,
        tlblXanguilla = 0,
        tlblYanguilla = 0,
        trbrXanguilla = 0,
        trbrYanguilla = 0;
    // tltrXanguilla = midpoint(leftA, rightA);
    // tltrYanguilla = midpoint(topA, topA);
    // blbrXanguilla = midpoint(leftA, rightA);
    // blbrYanguilla = midpoint(botA, botA);
    // tlblXanguilla = midpoint(leftA, leftA);
    // tlblYanguilla = midpoint(topA, botA);
    // trbrXanguilla = midpoint(rightA, rightA);
    // trbrYanguilla = midpoint(topA, botA);
    double distanceXanguilla = (rightA - leftA);
    double distanceYanguilla = (botA - topA);
    double distanceAnguilla = (distanceXanguilla + distanceYanguilla) / 2;
    double dimanguilla = distanceAnguilla / pixelsPerMetric;
    // double dimBanguilla = distanceYanguilla / pixelsPerMetric;

    misurazione = dimanguilla - 0.5;
    if (misurazione >= 0.1 && misurazione < 6.6) {
      risultato = 1;
    } else if (misurazione >= 6.6 && misurazione < 7) {
      risultato = 0;
    } else {
      risultato = -1;
    }
  }

  GetPrediction(int index, String percorsoFoto, bool mod, String nomeComp,
      double lat, double long, String ora, String data) {
    platform = MethodChannel('app.5i.lifeel.dev/tensorflow');
    _index = index;
    dinamica = mod;
    if (dinamica == true) {
      percorso = percorsoFoto;
    } else {
      percorso = "/data/user/0/com.example.app_5ij/app_flutter/freel/foto2.jpg";
    }

    nomeFoto = nomeComp;
    latitude = lat;
    longitude = long;
    oraFoto = ora;
    dataFoto = data;

    _getPrediction();
  }

  Future<void> _getPrediction() async {
    String prediction;
    final m = Mutex();
    m.acquire();
    try {
      final String result = await platform
          .invokeMethod('getOcchio', <String, dynamic>{'percorso': percorso});
      List<String> split = result.split("/");
      if ((split[0].contains("occhio") && split[2].contains("moneta")) ||
          (split[0].contains("moneta") && split[2].contains("occhio"))) {
        String occhio;
        String moneta;

        if (split[0].contains("occhio")) {
          occhio = split[1];
          moneta = split[3];
          List<String> splitOcchio = occhio.split("|");
          List<String> splitMoneta = moneta.split("|");
          misura(
              width[_index],
              double.parse(splitMoneta[0]),
              double.parse(splitMoneta[1]),
              double.parse(splitMoneta[2]),
              double.parse(splitMoneta[3]),
              double.parse(splitOcchio[0]),
              double.parse(splitOcchio[1]),
              double.parse(splitOcchio[2]),
              double.parse(splitOcchio[3]));
        } else {
          occhio = split[3];
          moneta = split[1];
          List<String> splitOcchio = occhio.split("|");
          List<String> splitMoneta = moneta.split("|");
          misura(
              width[_index],
              double.parse(splitMoneta[0]),
              double.parse(splitMoneta[1]),
              double.parse(splitMoneta[2]),
              double.parse(splitMoneta[3]),
              double.parse(splitOcchio[0]),
              double.parse(splitOcchio[1]),
              double.parse(splitOcchio[2]),
              double.parse(splitOcchio[3]));
        }
      } else {
        throw new Exception("Non è presente occhio e/o moneta");
      }

      print(result);
      print(misurazione);
      print(risultato);

      final int ris = await DBFoto.creaFoto(nomeFoto, percorso, risultato,
          misurazione, latitude, longitude, dataFoto, oraFoto);
      if (ris > 0) {
        print("Inserimento nel database effettuato");
      } else {
        print("Inserimento nel database non effettuato");
      }
    } on Exception catch (e) {
      prediction = e.toString();
    } finally {
      m.release();
    }
  }
}
