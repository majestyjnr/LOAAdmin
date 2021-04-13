import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddVideo extends StatefulWidget {
  AddVideo({Key key}) : super(key: key);

  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  String dropdownValue = 'Acquisition Section';
  File _video;

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
              (_video != null)
                  ? (_videoPlayerController.value.isPlaying)
                  : _videoPlayerController.pause();
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
                child: Text(
                  'Upload Video',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
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
