import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_app/camera.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

String? vidPath;

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late VideoPlayerController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        cupertino: (_, __) => CupertinoNavigationBarData(
          backgroundColor: Colors.white,
          title: Text(
            "Video App",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          trailing: CupertinoButton(
            onPressed: () async {
              bool? reload = await Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) {
                  return Camera();
                }),
              );
              if (reload != null) setState(() {});
            },
            child: Icon(
              CupertinoIcons.camera,
              color: Colors.black,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          backgroundColor: Colors.purple,
          title: Text(
            "Video App",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: PlatformWidget(
        cupertino: (_, __) => Expanded(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              alignment: Alignment.center,
              child: Text(vidPath == null
                  ? 'Recorded video is desplayed here'
                  : vidPath!),
            ),
          ),
        ),
        material: (_, __) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 40),
            Container(
              child: vidPath == null
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(vidPath == null
                              ? 'Recorded video is desplayed here'
                              : vidPath!),
                        ),
                      ),
                    )
                  : Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_controller.value.isPlaying)
                              _controller.pause();
                            else
                              _controller.play();
                          });
                        },
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () async {
                      bool? reload = await Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Camera();
                      }));
                      if (reload != null) {
                        print(vidPath);
                        setState(() {
                          _controller =
                              VideoPlayerController.file(File(vidPath!));
                          _controller.addListener(() {});
                          _controller.initialize();
                        });
                      }
                    },
                    child: Icon(Icons.camera),
                    backgroundColor: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
