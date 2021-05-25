import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'gallery.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'dart:io';

late List<CameraDescription> cameras;

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _cameraController;
  late Future<void> cameraValue;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        cupertino: (_, __) => CupertinoNavigationBarData(
          backgroundColor: Colors.white,
          title: Text(
            "Camera",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          trailing: CupertinoButton(
            onPressed: () {},
            child: Icon(
              Icons.flash_off,
              color: Colors.black,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          backgroundColor: Colors.purple,
          title: Text(
            "Camera",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, frame) {
              if (frame.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController);
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          PlatformWidget(
            cupertino: (_, __) => Positioned(
              bottom: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 50),
                        CupertinoButton(
                          onPressed: () async {
                            if (!isRecording) {
                              await _cameraController.startVideoRecording();
                              setState(() {
                                isRecording = true;
                              });
                            } else {
                              XFile vid =
                                  await _cameraController.stopVideoRecording();
                              File(vid.path)
                                  .copy('/storage/emulated/0/Download/vid.mp4');
                              File(vid.path).delete();
                              vidPath = '/storage/emulated/0/Download/vid.mp4';
                              setState(() {
                                isRecording = false;
                              });
                              Navigator.pop(context, true);
                            }
                          },
                          child: isRecording
                              ? Icon(
                                  Icons.radio_button_on,
                                  color: Colors.red,
                                  size: 80,
                                )
                              : Icon(
                                  Icons.panorama_fish_eye,
                                  color: Colors.white,
                                  size: 70,
                                ),
                          padding: EdgeInsets.only(bottom: 5),
                        ),
                        CupertinoButton(
                          onPressed: () {},
                          child: Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 38,
                          ),
                          padding: EdgeInsets.only(bottom: 5),
                        ),
                      ],
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: Container(
                        color: Colors.black,
                        padding: EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Tap to Record",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            material: (_, __) => Positioned(
              bottom: 0.0,
              child: Container(
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (!isRecording) {
                              await _cameraController.startVideoRecording();
                              setState(() {
                                isRecording = true;
                              });
                            } else {
                              XFile vid =
                                  await _cameraController.stopVideoRecording();
                              File(vid.path)
                                  .copy('/storage/emulated/0/Download/vid.mp4');
                              File(vid.path).delete();
                              vidPath = '/storage/emulated/0/Download/vid.mp4';
                              setState(() {
                                isRecording = false;
                              });
                              Navigator.pop(context, true);
                            }
                          },
                          child: isRecording
                              ? Icon(
                                  Icons.radio_button_on,
                                  color: Colors.red,
                                  size: 80,
                                )
                              : Icon(
                                  Icons.panorama_fish_eye,
                                  color: Colors.white,
                                  size: 70,
                                ),
                        ),
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.flip_camera_android,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tap to Record",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
