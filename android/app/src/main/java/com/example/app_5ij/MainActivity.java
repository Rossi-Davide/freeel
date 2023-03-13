package com.example.app_5ij;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "app.5i.lifeel.dev/tensorflow";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            // This method is invoked on the main thread.
            // TODO
            if (call.method.equals("getOcchio")) {
              String prova = getOcchio();

              if (prova != null) {
                result.success(prova);
              } else {
                result.error("UNAVAILABLE", "Prediction not available", null);
              }
            } else {
              result.notImplemented();
            }
          }
        );
  }


  private String getOcchio(){
    return "arrived";
  }
}