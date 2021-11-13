import 'dart:io';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rcn/screens/view_video_screen.dart';

class VideoMessagePlayerWidgetOriginal extends StatefulWidget {
  VideoMessagePlayerWidgetOriginal({
    Key? key,
    required this.vid_image,
    required this.vid_link,
    required this.vid_title,
    required this.vid_id,
    //required this.vid_album,
  }) : super(key: key);

  String vid_image;
  String vid_link;
  String vid_title;
  String vid_id;
  //String vid_album;

  @override
  _VideoMessagePlayerWidgetOriginalWidgetState createState() =>
      _VideoMessagePlayerWidgetOriginalWidgetState();
}

class _VideoMessagePlayerWidgetOriginalWidgetState
    extends State<VideoMessagePlayerWidgetOriginal> {
  late String _localPath;
  bool downloading = false;
  var progressString = "";
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: Card(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    '${widget.vid_image}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: Icon(
                        Icons.play_circle_filled_sharp,
                        color: Colors.redAccent,
                        size: 45.0,
                      ),
                      onPressed: () {
                        Get.to(
                          () => ViewVideoScreen(
                            youTubeLink: widget.vid_link,
                            youTubeTitle: widget.vid_title,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        Text(
                          '${widget.vid_title}',
                          maxLines: 2,
                        ),
                        (downloading)
                            ? Container(
                                padding: const EdgeInsets.only(top: 8.0),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 5,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert_sharp,
                    ),
                    enabled: true,
                    onSelected: (value) async {
                      if (value == 'Play') {
                        Get.to(
                          () => ViewVideoScreen(
                            youTubeLink: widget.vid_link,
                            youTubeTitle: widget.vid_title,
                          ),
                        );
                      } else if (value == 'Download') {
                        String youtubeName =
                            widget.vid_title.split('.').join("");
                        setState(() {
                          downloading = true;
                        });
                        await _prepare();
                        downloadFile(widget.vid_link, youtubeName);

                        if (downloading == true) {
                          showSnackBar("Downloading",
                              "Audio Message is downloading...", Colors.black);
                        } else if (downloading == false) {
                          showSnackBar(
                              "Download Completed",
                              "Audio Message has been saved into your device, enjoy!...",
                              Colors.black);
                        }
                      } else if (value == 'Playlist') {}
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Play"),
                        value: "Play",
                      ),
                      PopupMenuItem(
                        child: Text("Download"),
                        value: "Download",
                      ),
                      PopupMenuItem(
                        child: Text("Add to Playlist"),
                        value: "Playlist",
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _prepare() async {
    final status = await Permission.storage.request();
    // final status = (Platform.isAndroid)
    //     ? await Permission.storage.request()
    //     : await Permission.photos.request();

    // print(status);
    if (status.isGranted) {
      await _prepareSaveDir();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<void> downloadFile(String url, var file_name) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();

      await dio.download(url, "${_localPath}/$file_name.mp3",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          progress = rec / total;
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    showSnackBar(
      'Congratulation',
      'File Downloaded successfully',
      Colors.green,
    );
  }

  showSnackBar(String title, String msg, Color backgroundColor) {
    // Get.snackbar(
    //   title,
    //   msg,
    //   backgroundColor: backgroundColor,
    //   colorText: Colors.white,
    //   snackPosition: SnackPosition.BOTTOM,
    // );

    Get.snackbar(
      title,
      msg,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}