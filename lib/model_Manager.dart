import 'dart:io';
import 'dart:async';
import 'package:better_open_file/better_open_file.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart'; 





class GetPrediction{

  static var platform;

 
  GetPrediction() {
    platform = MethodChannel('app.5i.lifeel.dev/tensorflow');
    
    _getPrediction();

    
  }

 

  Future<void> _getPrediction() async {
    String prediction;

    try {
      final String result = await platform.invokeMethod('getOcchio');

      var a = 5;

      print(a);
      print(result);
    
    } on PlatformException catch (e) {
      prediction = "Failed to get prediction";
    }
  }

  
}