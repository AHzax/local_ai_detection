import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:local_ai_detection/features/home/presentation/bloc/home_state.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FlutterVision vision = FlutterVision();
  HomeBloc() : super(const HomeState()) {
    on<InitHomeEvent>((event, emit) async {
      await _initCamera(event, emit);
      await loadYoloModel();
      await state.controller?.startImageStream((image) async {
        add(HomeYoloResultEvent(image: image));
      });
    });
    on<HomeYoloResultEvent>((event, emit) async {
      final result = await yoloOnFrame(event.image);
      log("HomeYoloResultEvent=====> $result");

      emit(
        state.copyWith(
          yoloResults: List.from(state.yoloResults)..addAll(result),
        ),
      );
    });
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/models/cig_labels.txt',
      modelPath: 'assets/models/cig_mb_float16v2.tflite',
      modelVersion: "yolov8",
      numThreads: 1,
      useGpu: true,
    );
  }

  Future<CameraController> _initCamera(
    InitHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    final cameras = await availableCameras();
    final camera =
        cameras.firstWhere((e) => e.lensDirection == CameraLensDirection.front);
    final newstate = state.copyWith(
      controller: CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      ),
    );
    await newstate.controller?.initialize();
    await newstate.controller
        ?.lockCaptureOrientation(DeviceOrientation.portraitUp);
    emit(newstate);
    return newstate.controller!;
  }

  Future<List<Map<String, dynamic>>> yoloOnFrame(
    CameraImage cameraImage,
  ) {
    return vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.4,
    );
  }

  @override
  Future<void> close() async {
    await state.controller?.dispose();
    return super.close();
  }
}
