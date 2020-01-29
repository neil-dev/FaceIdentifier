import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'dart:io';
import 'dart:ui' as ui;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FacePage(),
    );
  }
}

class FacePage extends StatefulWidget {
  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  File _imageFile;
  List<Face> _faces;
  ui.Image _image;

  void _getImageAndDetectFaces() async {
    _image = null;
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
    final faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
      });
    }
  }

  Future<void> _loadImage(File file) async {
    print('$file');

    final data = await file.readAsBytes();

    final img = await decodeImageFromList(data);
    if (_image == null) {
      setState(() {
        _image = img;
      });
    }
  }

  Widget _buildImage() {
    _loadImage(_imageFile);

    if (_image != null) {
      return CustomPaint(
        painter: FacePainter(_image, _faces.map((f) => f.boundingBox).toList()),
      );
    } else {
      return new Center(child: new Text('loading'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detector'),
      ),
      body: _imageFile == null
          ? Center(
              child: Text('Pick an image'),
            )
          : Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: LayoutBuilder(
                      builder: (_, constraints) => Container(
                        width: constraints.widthConstraints().maxWidth,
                        height: constraints.heightConstraints().maxHeight,
                        child: _buildImage(),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ListView(
                      children: _faces.map((f) => FaceCoordinates(f)).toList(),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImageAndDetectFaces,
        tooltip: 'Pick an image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class FaceCoordinates extends StatelessWidget {
  final Face face;
  FaceCoordinates(this.face);

  @override
  Widget build(BuildContext context) {
    final pos = face.boundingBox;
    return ListTile(
      title: Text('(${pos.top}, ${pos.left} ${pos.bottom}, ${pos.right})'),
    );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Rect> faces;
  FacePainter(this.image, this.faces);

  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(
          faces[i],
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0
            ..color = Colors.red);
    }
  }

  bool shouldRepaint(FacePainter oldDelegate) =>
      image != oldDelegate.image || faces != oldDelegate.faces;
}
