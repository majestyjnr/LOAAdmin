import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddVideo extends StatefulWidget {
  AddVideo({Key key}) : super(key: key);

  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  TextEditingController _videoDescription = new TextEditingController();

  String dropdownValue = 'Acquisition Section';
  File _video;
  bool isLoading = false;
  dynamic _progress;
  dynamic id = Uuid().v1();

  VideoPlayerController _videoPlayerController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          'Add Video',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image(
            image: AssetImage('assets/images/uew.png'),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              (_progress == null)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Uploading ${(_progress * 100).toStringAsFixed(2)}%...',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : Container(),
              Text('Select Video Section:'),
              DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                items: <String>[
                  'Acquisition Section',
                  'Circulation Section',
                  'Information Help Desk Section',
                  'Lending Section',
                  'Quick Reference Section',
                  'Reference Section',
                  'Security Section',
                  'Special Section'
                ].map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (String newLevel) {
                  setState(() {
                    dropdownValue = newLevel;
                  });
                },
              ),
              TextField(
                maxLines: null,
                minLines: 3,
                controller: _videoDescription,
                decoration: InputDecoration(
                  labelText: 'Video Description',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    size: 30,
                  ),
                  onPressed: () async {
                    final file = await ImagePicker.platform.pickVideo(
                      source: ImageSource.gallery,
                    );
                    _video = File(file.path);
                    _videoPlayerController = VideoPlayerController.file(_video)
                      ..initialize().then((_) {
                        setState(() {
                          _videoPlayerController.play();
                        });
                      });
                  }),
              SizedBox(
                height: 15,
              ),
              Text('Attach Video'),
              SizedBox(
                height: 15,
              ),
              if (_video != null)
                _videoPlayerController.value.isInitialized
                    ? Material(
                        child: InkWell(
                          child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(
                              _videoPlayerController,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (_videoPlayerController.value.isPlaying) {
                                _videoPlayerController.pause();
                              } else {
                                _videoPlayerController.play();
                              }
                            });
                          },
                        ),
                      )
                    : Container(),
              (_video != null)
                  ? (_videoPlayerController.value.isPlaying)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Playing...',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Paused.',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                  : Container(),
              SizedBox(
                height: 50,
              ),
              MaterialButton(
                minWidth: double.infinity,
                height: 40,
                child: isLoading
                    ? NutsActivityIndicator(
                        activeColor: Colors.white,
                      )
                    : Text(
                        'Upload Video',
                        style: TextStyle(color: Colors.white),
                      ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    // Reference a collection to recieve the video
                    firebase_storage.Reference ref = firebase_storage
                        .FirebaseStorage.instance
                        .ref()
                        .child('videos')
                        .child(id);

                    // Store Video in the referenced collection
                    firebase_storage.UploadTask uploadTask =
                        ref.putFile(_video);

                    // Track Upload Progress
                    uploadTask.asStream().listen((event) {
                      setState(() {
                        _progress = event.bytesTransferred.toDouble() /
                            event.totalBytes.toDouble();
                      });
                    });

                    // GET video URL
                    var downloadURL =
                        await uploadTask.whenComplete(() {}).then((value) {
                      return value.ref.getDownloadURL();
                    });

                    // Convert downloadURL to a string
                    final String url = downloadURL.toString();

                    // Save the user details into the database
                    FirebaseFirestore.instance.collection('Videos Info').add({
                      'id': id,
                      'videoSection': dropdownValue,
                      'videoDescription': _videoDescription.text,
                      'videoURL': url,
                    }).then((value) {
                      _videoDescription.text = '';
                      setState(() {
                        isLoading = false;
                        _video = null;
                      });
                      Toast.show(
                        'Video successfully updated into the database.',
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.TOP,
                      );
                    });
                  } catch (e) {
                    _videoDescription.text = '';
                    _video = null;

                    setState(() {
                      isLoading = false;
                    });
                    Toast.show(
                      'Error uploading video to database.',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.TOP,
                    );
                  }
                },
                elevation: 0.5,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
