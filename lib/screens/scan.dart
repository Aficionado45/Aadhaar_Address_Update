import 'dart:io';

import 'package:aadhaar_address/screens/capture.dart';
import 'package:aadhaar_address/screens/confirm_address.dart';
import 'package:aadhaar_address/screens/user_login.dart';
import 'package:aadhaar_address/utils/feedback_form.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

enum AppState { free, picked, cropped, extracted }

class scanDoc extends StatefulWidget {
  const scanDoc();

  @override
  _scanDocState createState() => _scanDocState();
}

String address;

class _scanDocState extends State<scanDoc> {
  AppState state;
  File _image;
  bool error = false;
  bool isAsync = false;

  //Initial image contains the initial file
  File _initialImage;
  TextEditingController script = TextEditingController();
  final picker = ImagePicker();

  void updateData() {
    var db = FirebaseFirestore.instance;
    address = script.text;
    DateTime curr = DateTime.now();
    db.collection("ongoing").doc(userRefId).set({
      "scanned_address": address,
      "step": 2,
      "timestamp": curr,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: MediaQuery.of(context).size.height / 8,
          elevation: 0,
          leadingWidth: MediaQuery.of(context).size.width / 4,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Hero(
              tag: 'logo',
              child: Image(
                image: AssetImage('images/Aadhaar_Logo.svg'),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.help_outline_rounded,
                color: Color(0xFF143B40),
                size: 30,
              ),
              onPressed: () {
                getFeedback(context);
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: isAsync,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: MediaQuery.of(context).size.width / 6),
            children: [
              Center(
                child: Text(
                  "Scan Documents",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              if (state != AppState.free)
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
              _image == null
                  ? Text(
                      'No image selected.',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.file(_image)),
              if (state == AppState.extracted)
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: script,
                    minLines: 5,
                    maxLines: 100,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    onChanged: (val) {
                      setState(() {});
                    },
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                ),
              if (state == AppState.free)
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                          color: Colors.grey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Capture and upload a document",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 30)),
                                Icon(Icons.camera),
                              ])),
                    )),
              if (state == AppState.free)
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF143B40),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  alignment: FractionalOffset.center,
                  width: MediaQuery.of(context).size.width / 3,
                  height: 40,
                  child: FlatButton(
                    onPressed: () async {
                      setState(() {
                        isAsync = true;
                      });
                      await getImage();
                      setState(() {
                        isAsync = false;
                      });
                    },
                    child: Text(
                      "Capture Pic",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              if (state == AppState.picked || state == AppState.extracted)
                SizedBox(
                  height: 20,
                ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF143B40),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: FractionalOffset.center,
                width: MediaQuery.of(context).size.width / 5,
                height: 40,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      isAsync = false;
                    });
                    Navigator.pushNamed(context, 'scan');
                  },
                  child: Text(
                    "Capture Again",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF143B40),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: FractionalOffset.center,
                width: MediaQuery.of(context).size.width / 5,
                height: 40,
                child: FlatButton(
                  onPressed: () async {
                    setState(() {
                      isAsync = true;
                    });
                    await cropImage();
                    setState(() {
                      isAsync = false;
                    });
                  },
                  child: Text(
                    "Crop Document",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (state == AppState.picked || state == AppState.extracted)
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF143B40),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  alignment: FractionalOffset.center,
                  width: MediaQuery.of(context).size.width / 3,
                  height: 40,
                  child: FlatButton(
                    onPressed: () async {
                      setState(() {
                        state = AppState.cropped;
                        isAsync = true;
                      });
                      await getText();
                      setState(() {
                        isAsync = false;
                      });

                      if (script.text.length == 0)
                        setState(() {
                          error = true;
                        });
                    },
                    child: Text(
                      "Extract address",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              if (state == AppState.extracted)
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF143B40),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  alignment: FractionalOffset.center,
                  width: MediaQuery.of(context).size.width / 3,
                  height: 40,
                  child: FlatButton(
                    onPressed: () async {
                      setState(() {
                        isAsync = true;
                      });
                      //Line is commented out for testing
                      await uploadImage(
                          _initialImage, '$userRefId/document.png');
                      updateData();
                      setState(() {
                        isAsync = false;
                      });
                      Navigator.push(
                        context,
                        //AS A PARAMTER SEND UR ADDRESS for testing, ELSE we will have to send the extracted address i.e script.text
                        MaterialPageRoute(
                          builder: (context) =>
                              cnfrmAddress(address: script.text),
                        ),
                      );
                      // "34AROY M.C LAHIRI STREET ganesh apart ment, Chatra, Serampore, West Bengal 712204, India",
                    },
                    child: Text(
                      "Confirm Address and Proceed",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'No Address Found, Scan Again!',
                    style: TextStyle(
                        color: error ? Colors.red : Colors.white,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Image(
                image: AssetImage('images/Progress1.png'),
                width: MediaQuery.of(context).size.width * 0.67,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  //Operator captures document from camera
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _initialImage = _image;
        setState(() {
          state = AppState.picked;
        });
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Null> cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop the Image',
            toolbarColor: Color(0xff375079),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
  }

  //Reading address
  void getText() async {
    await readText(_image);
    setState(() {
      state = AppState.extracted;
    });
  }

  Future readText(File image) async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    script.clear();
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            script.text = script.text + " " + word.text;
          });
        }
        script.text = script.text + '\n';
      }
    }
    setState(() {});
  }
}
