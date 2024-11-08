// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:local_ai_detection/core/constants/app_colors.dart';
import 'package:local_ai_detection/core/gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterVision? vision;
  late CameraController controller;
  List<Map<String, dynamic>> yoloResults = [];
  CameraImage? cameraImage;
  bool isLoaded = false;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    init();
    vision = FlutterVision();
    super.initState();
  }

  init() async {
    cameras = await availableCameras();
    controller = CameraController(
        cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.low);
    await controller.initialize().then((value) async {
      await loadYoloModel().then((value) {
        setState(() {
          // isLoaded = true;
          yoloResults = [];
        });
      });
    });
    await controller.startImageStream((image) async {
      cameraImage = image;
      yoloOnFrame(image);
      log(yoloResults.length.toString());
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    cameras.clear();
  }

  Future<void> loadYoloModel() async {
    await vision?.loadYoloModel(
      labels: 'assets/models/labels.txt',
      modelPath: 'assets/models/yolov5n.tflite',
      modelVersion: "yolov5",
      numThreads: 1,
      useGpu: true,
    );
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await vision!.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.3,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
      print(
          "################yoloResults:::>-------${yoloResults.first["tag"]}------->");
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorY = screen.width / (cameraImage?.height ?? 1);
    double factorX = screen.height / 1.6 / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorY,
        bottom: result["box"][1] * factorX,
        width: (result["box"][2] - result["box"][0]) * factorY,
        height: (result["box"][3] - result["box"][1]) * factorX,
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detection Detail",
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: size.height / 1.5,
                width: size.width,
                child: isLoaded == false
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Stack(
                        // fit: StackFit.expand,
                        children: [
                          CameraPreview(controller),
                          ...displayBoxesAroundRecognizedObjects(size),
                        ],
                      )),
            SizedBox(height: 18.sp),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "Summary",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            SizedBox(height: 24.sp),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoCardWidget(
                        icon: Assets.svgs.alarm,
                        title: "Detected Time",
                        subTitle: yoloResults.isEmpty
                            ? 'none'
                            : '${_formatDigit(now.hour)}:${_formatDigit(now.minute)}:${_formatDigit(now.second)}',
                      ),
                    ],
                  ),
                  SizedBox(height: 24.sp),
                  InfoCardWidget(
                    icon: Assets.svgs.search,
                    title: "Detection Status",
                    subTitle: yoloResults.isEmpty
                        ? 'none'
                        : yoloResults.first["tag"].toString() == "phone"
                            ? "Detection is ${yoloResults.first["tag"]}"
                            : "Detection is ${yoloResults.first["tag"]}",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

String _formatDigit(int number) {
  return number.toString().padLeft(2, '0');
}

class InfoCardWidget extends StatelessWidget {
  final SvgGenImage icon;
  final String title;
  final String subTitle;
  const InfoCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon.svg(
            width: 22.sp,
            colorFilter: const ColorFilter.mode(
              AppColors.hint,
              BlendMode.srcIn,
            )),
        SizedBox(width: 12.sp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.hint,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6.sp),
            Text(
              subTitle,
              style: const TextStyle(
                color: AppColors.font2,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}

// class YoloVideo extends StatefulWidget {
//   final FlutterVision vision;
//   const YoloVideo({super.key, required this.vision});

//   @override
//   State<YoloVideo> createState() => _YoloVideoState();
// }

// class _YoloVideoState extends State<YoloVideo> {
//   late CameraController controller;
//   late List<Map<String, dynamic>> yoloResults;
//   CameraImage? cameraImage;
//   bool isLoaded = false;
//   List<CameraDescription> cameras = [];

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   init() async {
//     cameras = await availableCameras();
//     controller = CameraController(cameras[1], ResolutionPreset.low);
//     await controller.initialize().then((value) async {
//       await loadYoloModel().then((value) {
//         setState(() {
//           isLoaded = true;
//           yoloResults = [];
//         });
//       });
//     });
//     await controller.startImageStream((image) async {
//       cameraImage = image;
//       yoloOnFrame(image);
//       log(yoloResults.length.toString());
//     });
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//     controller.dispose();
//     cameras.clear();
//   }

  // @override
  // Widget build(BuildContext context) {
  //   final Size size = MediaQuery.of(context).size;

  //   if (!isLoaded) {
  //     return const Center(
  //       child: CircularProgressIndicator.adaptive(),
  //     );
  //   }
  //   return Stack(
  //     // fit: StackFit.expand,
  //     children: [
  //       CameraPreview(controller),
  //       ...displayBoxesAroundRecognizedObjects(size),
  //     ],
  //   );
  // }

//   Future<void> loadYoloModel() async {
//     await widget.vision.loadYoloModel(
//       labels: 'assets/cig_labels.txt',
//       modelPath: 'assets/cig_mb_float16.tflite',
//       modelVersion: "yolov8",
//       numThreads: 1,
//       useGpu: true,
//     );
//     setState(() {
//       isLoaded = true;
//     });
//   }

//   //running package on -->cameraImage and running it in -->start detection() and assign result to yolo result<---

//   Future<void> yoloOnFrame(CameraImage cameraImage) async {
//     final result = await widget.vision.yoloOnFrame(
//       bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
//       imageHeight: cameraImage.height,
//       imageWidth: cameraImage.width,
//       iouThreshold: 0.3,
//       confThreshold: 0.4,
//       classThreshold: 0.5,
//     );
//     if (result.isNotEmpty) {
//       setState(() {
//         yoloResults = result;
//       });
//       print("################result:::>-------$result------->");
//     }
//   }

// //Func widget to  displayBoxesAroundRecognizedObjects by using camera image size and using yolo result to map boxes aroung detected images
// //width , height from yoloresult["box"][0] print yoloresult to see this..! 0 to 3 indexes are sizes and 4th is confidence and second is tag out of box scope

// //yoloresult[{box: [8.183913230895996, 394.115966796875, 612.8524780273438, 611.808349609375, 0.6292821168899536], tag: phone}]

//   List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
//     if (yoloResults.isEmpty) return [];
//     double factorY = screen.width / (cameraImage?.height ?? 1);
//     double factorX = screen.height / 1.6 / (cameraImage?.width ?? 1);

//     Color colorPick = const Color.fromARGB(255, 50, 233, 30);

//     return yoloResults.map((result) {
//       return Positioned(
//         left: result["box"][0] * factorY,
//         bottom: result["box"][1] * factorX,
//         width: (result["box"][2] - result["box"][0]) * factorY,
//         height: (result["box"][3] - result["box"][1]) * factorX,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//             border: Border.all(color: Colors.pink, width: 2.0),
//           ),
//           child: Text(
//             "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
//             style: TextStyle(
//               background: Paint()..color = colorPick,
//               color: Colors.white,
//               fontSize: 18.0,
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }

// }
