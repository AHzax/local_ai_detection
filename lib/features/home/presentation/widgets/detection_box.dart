import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<Widget> displayBoxesAroundRecognizedObjects(
  Size screen,
  List<Map<String, dynamic>> result,
  CameraImage? cameraImage,
) {
  if (result.isEmpty) return [];
  double factorX = screen.width / (cameraImage?.height ?? 1);
  double factorY = screen.height / (cameraImage?.width ?? 1);

  Color colorPick = const Color.fromARGB(255, 50, 233, 30);

  return result.map((result) {
    return Positioned(
      left: result["box"][0] * factorX,
      top: result["box"][1] * factorY,
      width: (result["box"][2] - result["box"][0]) * factorX,
      height: (result["box"][3] - result["box"][1]) * factorY,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Colors.pink, width: 2.0),
        ),
        child: Text(
          "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
          style: TextStyle(
            background: Paint()..color = colorPick,
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }).toList();
}
