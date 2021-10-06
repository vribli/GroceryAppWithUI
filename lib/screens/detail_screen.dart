import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'request.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;

  const DetailScreen({this.imagePath});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _imagePath;
  ObjectDetector _objectDetector;
  TextDetector _textDetector;

  Size _imageSize;
  List<DetectedObject> _objects = [];

  List<String> _listStrings;

  // Fetching the image size from the image file
  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  // To detect the email addresses present in an image
  void _recognizeObjects() async {
    _getImageSize(File(_imagePath));

    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_imagePath);
    // Retrieving the RecognisedText from the InputImage
    final List<DetectedObject> objects = await _objectDetector.processImage(inputImage);
    final RecognisedText text = await _textDetector.processImage(inputImage);

    for (DetectedObject detectedObject in _objects) {
      final rect = detectedObject.getBoundinBox();
      final trackingId = detectedObject.getTrackingId();

      for (Label label in detectedObject.getLabels()) {
        print('${label.getText()} ${label.getConfidence()}');
      }
    }
    _objects = objects;

    List<String> emailStrings = [];
    List<String> listTexts = [];

    double highest_area = -1;
    var highest_object = null;

    // Finding and storing the text String(s) and the TextElement(s)
    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        print('text: ${line.text}');
        for (TextElement element in line.elements)
        {
          var height = element.rect.bottom - element.rect.top;
          var width = element.rect.right - element.rect.left;
          var area = height * width;
          if (area > highest_area) {
            highest_area = area;
            highest_object = element;
          }
          if (element.text != null) listTexts.add(element.text);
        }
      }
    }
    print(highest_area);
    print(highest_object);
    listTexts.remove(highest_object.text);
    print(listTexts);

    print("http://vribli.pythonanywhere.com/?keyword=" + highest_object.text + "+" + listTexts.join("+"));
    var request = await getAPI("http://vribli.pythonanywhere.com/?keyword=" + highest_object.text + "+" + listTexts.join("+"));
    var decodedData = jsonDecode(request);
    print(decodedData);

    for(var data in decodedData){
      emailStrings.add(data['Name']);
    }

    setState(() {
      _listStrings = emailStrings;
    });

  }

  @override
  void initState() {
    _imagePath = widget.imagePath;
    // Initializing the text detector
    _objectDetector = GoogleMlKit.vision.objectDetector(ObjectDetectorOptions());
    _textDetector = GoogleMlKit.vision.textDetector();
    _recognizeObjects();
    sleep(Duration(milliseconds:1000));
    super.initState();
  }

  @override
  void dispose() {
    // Disposing the text detector when not used anymore
    _objectDetector.close();
    _textDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Details"),
      ),
      body: _imageSize != null
          ? Stack(
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.black,
            child: CustomPaint(
              foregroundPainter: ObjectDetectorPainter(
                _imageSize,
                _objects,
              ),
              child: AspectRatio(
                aspectRatio: _imageSize.aspectRatio,
                child: Image.file(
                  File(_imagePath),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Identified",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      child: SingleChildScrollView(
                        child: _listStrings != null
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _listStrings.length,
                          itemBuilder: (context, index) =>
                              Text(_listStrings[index]),
                        )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
          : Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

// Helps in painting the bounding boxes around the recognized
// email addresses in the picture
class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter(this.absoluteImageSize, this.objects);

  final Size absoluteImageSize;
  final List<DetectedObject> objects;

  @override
  void paint(Canvas canvas, Size size) {
    print("PAINTING");
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(DetectedObject container) {
      return Rect.fromLTRB(
        container.getBoundinBox().left * scaleX,
        container.getBoundinBox().top * scaleY,
        container.getBoundinBox().right * scaleX,
        container.getBoundinBox().bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (DetectedObject object in objects) {
      canvas.drawRect(scaleRect(object), paint);
    }
  }

  @override
  bool shouldRepaint(ObjectDetectorPainter oldDelegate) {
    return true;
  }
}

