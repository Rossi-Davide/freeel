import 'dart:io';
import 'dart:async';
import 'package:better_open_file/better_open_file.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class GetPrediction {
  static var platform;

  double misurazione = 0;
  String risultato = "";
  double widthM = 21.25;

  double midpoint2(double x1, double x2) {
    return ((x1 + x2) * 0.5);
  }

  double midpoint1(double y1, double y2) {
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
    tltrX = midpoint2(leftM, rightM);
    tltrY = midpoint1(topM, topM);
    blbrX = midpoint2(leftM, rightM);
    blbrY = midpoint1(botM, botM);
    tlblX = midpoint2(leftM, leftM);
    tlblY = midpoint1(topM, botM);
    trbrX = midpoint2(rightM, rightM);
    trbrY = midpoint1(topM, botM);
    double distanceX = (tltrY - blbrY);
    double distanceY = (tlblX - trbrX);
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
    tltrXanguilla = midpoint2(leftA, rightA);
    tltrYanguilla = midpoint1(topA, topA);
    blbrXanguilla = midpoint2(leftA, rightA);
    blbrYanguilla = midpoint1(botA, botA);
    tlblXanguilla = midpoint2(leftA, leftA);
    tlblYanguilla = midpoint1(topA, botA);
    trbrXanguilla = midpoint2(rightA, rightA);
    trbrYanguilla = midpoint1(topA, botA);
    double distanceXanguilla = (tltrYanguilla - blbrYanguilla);
    double distanceYanguilla = (tlblXanguilla - trbrXanguilla);
    double dimAanguilla = distanceXanguilla / pixelsPerMetric;
    double dimBanguilla = distanceYanguilla / pixelsPerMetric;

    misurazione = (dimAanguilla + dimBanguilla) / 2;
    if (misurazione >= 0.1 && misurazione < 6.6) {
      risultato = "residente";
    } else if (misurazione >= 6.6 && misurazione < 7) {
      risultato = "migrante al 90%";
    } else {
      risultato = "migrante";
    }
  }

  GetPrediction(double width) {
    platform = MethodChannel('app.5i.lifeel.dev/tensorflow');
    widthM = width;
    _getPrediction();
  }

  Future<void> _getPrediction() async {
    String prediction;

    try {
      final String result = await platform.invokeMethod('getOcchio');
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
              widthM,
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
              widthM,
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
    } on Exception catch (e) {
      prediction = e.toString();
    }
  }
}
