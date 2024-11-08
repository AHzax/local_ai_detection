// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final CameraController? controller;
  final List<Map<String, dynamic>> yoloResults;
  final CameraImage? cameraImage;
  final bool isLoaded;

  const HomeState({
    this.controller,
    this.yoloResults = const [],
    this.cameraImage,
    this.isLoaded = false,
  });

  @override
  List<Object?> get props => [controller];

  @override
  bool get stringify => true;

  HomeState copyWith({
    CameraController? controller,
    List<Map<String, dynamic>>? yoloResults,
    CameraImage? cameraImage,
    bool? isLoaded,
  }) {
    return HomeState(
      controller: controller ?? this.controller,
      yoloResults: yoloResults ?? this.yoloResults,
      cameraImage: cameraImage ?? this.cameraImage,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
