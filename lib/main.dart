

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper/image_cropper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Imagecrop(),
    );
  }
}

class Imagecrop extends StatefulWidget {
  @override
  _ImagecropState createState() => _ImagecropState();
}

class _ImagecropState extends State<Imagecrop> {
      File _image;

      getImage(ImageSource source)async{
        var image = await ImagePicker.pickImage(
            source: source,
          
        );
        File cropperFile = await ImageCropper.cropImage(
          
            sourcePath:image.path,
                 aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                        CropAspectRatioPreset.original,
                   CropAspectRatioPreset.ratio4x3,
                   CropAspectRatioPreset.ratio16x9
           ],
          androidUiSettings: AndroidUiSettings(
             toolbarTitle: 'Cropper',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
          ),
          iosUiSettings: IOSUiSettings(
                  minimumAspectRatio: 1.0,
                ),
          maxWidth: 2180,
          maxHeight: 1440,
          
        );

        var result = await FlutterImageCompress.compressAndGetFile(
          image.path,
          cropperFile.path,
          minWidth: 2300,
          minHeight: 2300,
          quality: 100,
        );
              
              
              

        setState(() {
          _image = result;
        });

      }
  @override
  Widget build(BuildContext context) {
        print(_image?.lengthSync());
    return Scaffold(
      appBar: AppBar(
      title: Text('Image crop '),
      ),
      body: Center(
        child: Container(
          child: _image == null ?
          Text('Pick Image'):
              Image.file(
                _image,
                height: 500,
                width: 800,
              ),

        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton.extended(
            onPressed: () => getImage(ImageSource.camera),
            label: Text('Camera'),
          heroTag: UniqueKey(),
          icon: Icon(Icons.camera),
        ),
          FloatingActionButton.extended(
            onPressed: ()=> getImage(ImageSource.gallery),
            label: Text('Gallert'),
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
          ),

        ],
      ),
    );
  }
}

