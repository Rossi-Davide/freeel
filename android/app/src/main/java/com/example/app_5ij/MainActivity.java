package com.example.app_5ij;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.HashMap;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.icu.util.ULocale;
import android.util.Log;

import org.tensorflow.lite.Tensor;
import org.tensorflow.lite.support.image.TensorImage;
import org.tensorflow.lite.support.label.Category;
import org.tensorflow.lite.task.core.BaseOptions;
import org.tensorflow.lite.task.vision.detector.Detection;
import org.tensorflow.lite.task.vision.detector.ObjectDetector;
import org.tensorflow.lite.task.vision.detector.ObjectDetector.ObjectDetectorOptions;

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
            });
  }

  private String debugPrint(List<Detection> results) {
    String test = "";

    for (Detection obj : results) {

      List<Category> category = obj.getCategories();

      for (int i = 0; i < category.size(); i++) {
        test += category.get(i).getLabel() + "|";

      }

      RectF box = obj.getBoundingBox();
      test += box.left + "|" + box.top + "|" + box.right + "|" + box.bottom + "/" + "moneta" + "|" + 0 + "|" + 0 + "|"
          + 0 + "|" + 0;
    }

    return test;
  }

  private Bitmap drawDetectionResult(Bitmap bitmap, List<Detection> detectionResults) {
    Bitmap outputBitmap = bitmap.copy(Bitmap.Config.ARGB_8888, true);
    Canvas canvas = new Canvas(outputBitmap);
    Paint pen = new Paint();
    pen.setTextAlign(Paint.Align.LEFT);

    for (Detection detection : detectionResults) {
      // draw bounding box
      pen.setColor(Color.RED);
      pen.setStrokeWidth(4F);
      pen.setStyle(Paint.Style.STROKE);
      RectF box = detection.getBoundingBox();
      canvas.drawRect(box, pen);
    }
    return outputBitmap;
  }

  private String getOcchio() {
    try {

      // Initialization
      ObjectDetectorOptions options = ObjectDetectorOptions.builder()
          .setBaseOptions(BaseOptions.builder().useGpu().build())
          .setMaxResults(2)
          .setScoreThreshold(0.4f)
          .build();

      Context context = getApplicationContext();

      ObjectDetector objectDetector = ObjectDetector.createFromFileAndOptions(context, "android.tflite", options);

      File mSaveBit = new File(context.getCacheDir(), "test/prova2.jpg");
      String filePath = mSaveBit.getPath();
      Bitmap imageBitmap = BitmapFactory.decodeFile(filePath);

      TensorImage image = TensorImage.fromBitmap(imageBitmap);

      List<Detection> results = objectDetector.detect(image);

      String test = debugPrint(results);

      Bitmap rectImage = drawDetectionResult(imageBitmap, results);

      // create a file to write bitmap data
      File f = new File(context.getCacheDir(), "rectImage.png");
      f.createNewFile();

      ByteArrayOutputStream bos = new ByteArrayOutputStream();
      rectImage.compress(Bitmap.CompressFormat.PNG, 0, bos);
      byte[] bitmapData = bos.toByteArray();

      // write the bytes in file
      FileOutputStream fos = new FileOutputStream(f);
      fos.write(bitmapData);
      fos.flush();
      fos.close();

      String path = context.getCacheDir() + "/rectImage.png";

      return test;

    } catch (Exception e) {
      return e.getMessage();
    }

  }
}