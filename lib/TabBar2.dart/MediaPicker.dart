import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:dominators/TabBar2.dart/MediaView.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:photo_view/photo_view.dart';

class MediaPicker extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MediaPicker({Key key, this.cameras}) : super(key: key);

  @override
  _MediaPickerState createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffkey = GlobalKey<ScaffoldState>();
  CameraController controller;

  PersistentBottomSheetController bottomSheetController;
  String saveTo;
  List<FileSystemEntity> imageFiles = [];
  List<FileSystemEntity> selectedfiles = [];

  @override
  void initState() {
    super.initState();
    getAlbums();

    controller = CameraController(widget.cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  getAlbums() async {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    String path = storageInfo[0].rootDir + '/DCIM/Camera';
    saveTo = path;

    Directory dir = Directory(path);
    final p = await dir.exists();
    print(p.toString());
    print('------------------------' + path);
    // List<FileSystemEntity> files =
    dir.list().listen((file) {
      String mimeType = mime(basename(file.path).toLowerCase());
      String type = mimeType == null ? "" : mimeType.split("/")[0];

      if (type == 'image') {
        setState(() {
          imageFiles.add(file);
        });
      }
    });

    // }
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      controller = CameraController(widget.cameras[1], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffkey,
        backgroundColor: Colors.blueGrey[200],
        body: Container(
          height: size.height,
          width: size.width,
          child: Stack(children: <Widget>[
            CameraPreview(controller),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.27,
                child: Column(children: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onVerticalDragDown: (value) {
                        print(value.toString());
                        _animationController.forward();

                        bottomSheetController = _scaffkey.currentState
                            .showBottomSheet((context) => FadeTransition(
                                  opacity: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(_animationController),
                                  child: Container(
                                    height: size.height * 0.9,
                                    color: Colors.white,
                                    child: imageFiles == null
                                        ? LinearProgressIndicator()
                                        : Column(
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: GestureDetector(
                                                  onVerticalDragDown:
                                                      (value) async {
                                                    _animationController
                                                        .reverse();
                                                    bottomSheetController
                                                        .close();
                                                    selectedfiles.clear();
                                                    // _scaffkey.
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    child: Transform.rotate(
                                                        angle: -pi / 2,
                                                        child: Icon(
                                                          Icons.arrow_back_ios,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Container(
                                                  child: GridView.builder(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      childAspectRatio: 1.0,
                                                      crossAxisCount: 3,
                                                    ),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    primary: true,
                                                    itemCount:
                                                        imageFiles.length,
                                                    itemBuilder: (_, i) {
                                                      return GestureDetector(
                                                        onVerticalDragUpdate:
                                                            (value) {
                                                          // if (_scrollController
                                                          //         .initialScrollOffset ==
                                                          //     _scrollController
                                                          //         .position
                                                          //         .minScrollExtent) {
                                                          //   bottomSheetController
                                                          //       .close();
                                                          // }
                                                        },
                                                        onHorizontalDragStart:
                                                            (value) {
                                                          print(
                                                              value.toString());
                                                          if (selectedfiles
                                                                  .length !=
                                                              0) {
                                                            bottomSheetController
                                                                .setState(() {
                                                              selectedfiles.add(
                                                                  imageFiles[
                                                                      i]);
                                                            });
                                                          }
                                                        },
                                                        onHorizontalDragUpdate:
                                                            (value) {
                                                          print("--" +
                                                              value.toString());
                                                        },
                                                        // onHorizontalDragCancel:
                                                        //     () {
                                                        //   print('cancel');
                                                        // },

                                                        // onVerticalDragDown:
                                                        //     (value) {
                                                        //   print(value.toString());
                                                        // },
                                                        onLongPress: () {},
                                                        onLongPressStart:
                                                            (value) {
                                                          print(
                                                              value.toString());

                                                          bottomSheetController
                                                              .setState(() {
                                                            selectedfiles.add(
                                                                imageFiles[i]);
                                                          });
                                                        },
                                                        // onLongPressEnd: (value) {
                                                        //   print(value.toString());
                                                        // },
                                                        onTap: () {
                                                          if (selectedfiles
                                                              .contains(
                                                                  imageFiles[
                                                                      i])) {
                                                            bottomSheetController
                                                                .setState(() {
                                                              selectedfiles
                                                                  .remove(
                                                                      imageFiles[
                                                                          i]);
                                                            });
                                                          } else if (selectedfiles
                                                                  .length !=
                                                              0) {
                                                            bottomSheetController
                                                                .setState(() {
                                                              selectedfiles.add(
                                                                  imageFiles[
                                                                      i]);
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  5.0),

                                                          color:
                                                              Colors.redAccent,
                                                          child: Stack(
                                                              fit: StackFit
                                                                  .expand,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Image(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      FileImage(
                                                                    File(imageFiles[
                                                                            i]
                                                                        .path),
                                                                  ),
                                                                ),
                                                                selectedfiles.contains(
                                                                        imageFiles[
                                                                            i])
                                                                    ? Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                5.0),
                                                                        alignment:
                                                                            Alignment
                                                                                .topRight,
                                                                        color: Colors
                                                                            .blueAccent
                                                                            .withOpacity(
                                                                                0.3),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .check_circle,
                                                                          color:
                                                                              Colors.lightBlueAccent,
                                                                        ))
                                                                    : SizedBox()
                                                              ]),
                                                          // child: ,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ));
                      },
                      child: Transform.rotate(
                          angle: pi / 2,
                          child: Icon(Icons.arrow_back_ios_rounded)),
                    ),
                  ),
                  imageFiles == null
                      ? LinearProgressIndicator()
                      : Flexible(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: imageFiles.length,
                            itemBuilder: (_, i) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      HeroDialogRoute(
                                          builder: (BuildContext context) =>
                                              ShotPhotoView(
                                                file: imageFiles[i].path,
                                              )));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5.0),
                                  height: 60,
                                  width: 80,
                                  color: Colors.redAccent,
                                  child: Image(
                                      fit: BoxFit.cover,
                                      image:
                                          FileImage(File(imageFiles[i].path))),
                                  // child: ,
                                ),
                              );
                            },
                          ),
                        ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          flashWidget(() {
                            print('pressed');
                            toggleFlash(controller.value.flashMode.index);
                          }),
                          IconButton(
                              icon: Icon(
                                Icons.camera,
                                size: 40,
                              ),
                              onPressed: () {
                                onShot(context);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.flip_camera_android,
                                size: 30,
                              ),
                              onPressed: () {
                                toggleCamera(controller.description);
                              })
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ));
  }

  onShot(BuildContext context) async {
    final image = await controller.takePicture();
    print(image.path);
    final path = join(
      saveTo,
      '${DateTime.now().toString().replaceAll(" ", "-").replaceAll(":", "_")}',
    );
    image.saveTo(path).onError((error, stackTrace) {
      print(error.toString());
      print("something went wrong");
    });
    // final exist = await Directory(path).exists();
    // print(exist.toString());
    // final file = File(path);
    // final ima = await image.readAsBytes();
    // await file.writeAsBytes(ima);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ShotPhotoView(
                  file: image.path,
                )));
  }

  Widget flashWidget(Function flash) {
    Widget flashWidget;
    switch (controller.value.flashMode) {
      case FlashMode.off:
        {
          flashWidget = IconButton(
            icon: Icon(Icons.flash_off),
            onPressed: flash,
          );
        }
        break;
      case FlashMode.auto:
        {
          flashWidget = IconButton(
            icon: Icon(Icons.flash_auto),
            onPressed: flash,
          );
        }
        break;
      case FlashMode.torch:
        {
          flashWidget = IconButton(
            icon: Icon(Icons.highlight),
            onPressed: flash,
          );
        }
        break;
      case FlashMode.always:
        {
          flashWidget = IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: flash,
          );
        }
    }
    return flashWidget;
  }

  toggleFlash(int value) async {
    print(value.toString());
    if (value == 3) {
      value = 0;
      await controller.setFlashMode(FlashMode.values[value]);
    } else {
      value++;
      await controller.setFlashMode(FlashMode.values[value]);
    }
    setState(() {});
  }

  toggleCamera(CameraDescription c) {
    if (widget.cameras[0] == c) {
      controller = CameraController(widget.cameras[1], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else if (widget.cameras[1] == c) {
      controller = CameraController(widget.cameras[0], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String get barrierLabel => null;
}
