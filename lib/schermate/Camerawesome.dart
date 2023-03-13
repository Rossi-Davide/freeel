import 'dart:io';
import 'dart:async';
import 'package:better_open_file/better_open_file.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart'; 

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.custom(
        builder: (cameraState, previewSize, previewRect) {
          return cameraState.when(
            onPreparingCamera: (state) =>
            const Center(child: CircularProgressIndicator()),
            onPhotoMode: (state) => TakePhotoUI(state),
          );
        },
        saveConfig: SaveConfig.photo(
          pathBuilder: () async {
            return "/data/data/com.example.app_5ij/cache/test/prova.jpg";
          },
        ),
      ),
    );
  }
}

class TakePhotoUI extends StatelessWidget {
  final PhotoCameraState state;

  const TakePhotoUI(this.state, {super.key});
  

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10 , 0, 10),
                  child: AwesomeFlashButton(state: state)
                ),
                const Spacer(),
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: AwesomeAspectRatioButton(state: state)
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 10, 0),
                  child: AwesomeLocationButton(state: state),
                )
              ]
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0 , 0, 15),
                child: AwesomeCaptureButton(state: state),
              ),
            ]
          ),

      ]
    );
  }
}
