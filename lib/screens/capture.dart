import 'dart:convert';
import 'dart:typed_data';

import 'package:aadhaar_address/screens/scan.dart';
import 'package:aadhaar_address/screens/user_login.dart';
import 'package:aadhaar_address/services/authentication_methods.dart';
import 'package:aadhaar_address/utils/constans.dart';
import 'package:aadhaar_address/utils/feedback_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:xml/xml.dart';

class capture extends StatefulWidget {
  const capture();

  @override
  _captureState createState() => _captureState();
}

void updateData() {
  var db = FirebaseFirestore.instance;
  DateTime curr = DateTime.now();
  db.collection("ongoing").doc(userRefId).set({
    "step": 4,
    "timestamp": curr,
  }, SetOptions(merge: true));
}

// Pick image from camera
Future pickImageFromCamera(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  try {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: MediaQuery.of(context).size.height / 4,
      maxWidth: MediaQuery.of(context).size.height / 3.5,
    );
    return pickedFile;
  } catch (err) {
    print(err);
  }
}

// Upload image file to destination on Firebase Storage
// : if request.auth != null;
Future<void> uploadImage(File image, String storageDestinationPath) async {
  try {
    await FirebaseStorage.instance.ref(storageDestinationPath).putFile(image);
  } on FirebaseException catch (err) {
    print(err.toString());
  }
}

File userImage;
File operatorImage;

class _captureState extends State<capture> {
  bool userUploaded = false;
  bool operatorUploaded = false;
  bool error = false;
  bool isAsync = false;
  String op_aadhar;
  String captchavalue;
  Widget captchaimage;
  String captchatxnid;
  String otp;
  bool errorotp = false;
  String facerdmessage = "";
  static const platform = const MethodChannel('going.native.for.userdata');

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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 7.5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Capture User and Operator Images",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      userUploaded
                          ? Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Image(
                          image: FileImage(
                            userImage,
                          ),
                        ),
                      )
                          : Icon(
                        Icons.person_outline_rounded,
                        color: kButton,
                        size: MediaQuery.of(context).size.height / 4,
                      ),
                      Text(
                        'User',
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        child: userUploaded
                            ? Icon(
                          Icons.check,
                          color: Colors.green,
                          size: MediaQuery.of(context).size.height / 16,
                        )
                            : IconButton(
                          onPressed: () async {
                            await getaadhaarwidget("user");
                          },
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            color: kButton,
                          ),
                          iconSize:
                          MediaQuery.of(context).size.height / 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      operatorUploaded
                          ? Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Image(
                          image: FileImage(
                            operatorImage,
                          ),
                        ),
                      )
                          : Icon(
                        Icons.person_outline_rounded,
                        size: MediaQuery.of(context).size.height / 4,
                      ),
                      Text(
                        'Operator',
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        child: operatorUploaded
                            ? Icon(
                          Icons.check,
                          color: Colors.green,
                          size: MediaQuery.of(context).size.height / 16,
                        )
                            : IconButton(
                          onPressed: () async {
                            await getaadhaarwidget("operator");
                          },
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            color: kButton,
                          ),
                          iconSize:
                          MediaQuery.of(context).size.height / 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kButton,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    alignment: FractionalOffset.center,
                    width: MediaQuery.of(context).size.width / 4,
                    height: 40,
                    child: FlatButton(
                      onPressed: () async {
                        setState(() {
                          error = false;
                          isAsync = false;
                        });
                        Navigator.pushReplacementNamed(context, 'confirmation');
                      },
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          color: kButtonText,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kButton,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    alignment: FractionalOffset.center,
                    width: MediaQuery.of(context).size.width / 4,
                    height: 40,
                    child: FlatButton(
                      onPressed: () async {
                        setState(() {
                          isAsync = true;
                        });
                        if (userUploaded && operatorUploaded) {
                          setState(() {
                            error = false;
                          });

                          await uploadImage(userImage, '$userRefId/user.png');

                          await uploadImage(
                              operatorImage, '$userRefId/operator.png');
                          setState(() {
                            isAsync = false;
                          });
                          Navigator.pushNamed(context, "confirm");
                        } else {
                          setState(() {
                            error = true;
                            isAsync = false;
                          });
                        }
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: kButtonText,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Center(
                child: Text(
                  'Please capture both images',
                  style: TextStyle(
                      color: error ? Colors.red : Colors.white,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  'OTP is incorrect',
                  style: TextStyle(
                      color: errorotp ? Colors.red : Colors.white,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  facerdmessage,textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Image(
                  image: AssetImage('images/Progress3.png'),
                  width: MediaQuery.of(context).size.width * 0.67,
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  bool errorcaptcha = false;
  String otpmessage = "";

  //ALERT DIALOG FOR GETTING AADHAAR
  Future<void> getaadhaarwidget(String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Aadhar Number of ${type}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 13.6,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Open Sans',
                      fontSize: 20,
                    ),
                    onChanged: (value) {
                      if (value.isEmpty)
                        return null;
                      else {
                        op_aadhar = value;
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          // color: Colors.redAccent,
                            width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          // color: Colors.redAccent,
                            width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      filled: true,
                      labelStyle: kSubHeaderStyle,
                      labelText: "Operator Aadhaar Number",
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: kButtonText,
              ),
              child: const Text('Next'),
              onPressed: () async {
                if (op_aadhar != null && op_aadhar.length == 12) {
                  print('Conditions are true.');
                  Navigator.pop(context);
                  setState(() {
                    isAsync = true;
                  });
                  Map<String, dynamic> responsebody = await getcaptcha();
                  //decoding response

                  setState(() {
                    error = false;
                    print('No errors');
                    print(responsebody.toString());
                    var captchaBase64String =
                    responsebody["captchaBase64String"];
                    captchatxnid = responsebody["captchaTxnId"];
                    Uint8List bytes =
                    Base64Decoder().convert(captchaBase64String);
                    captchaimage = Image.memory(bytes);
                  });
                  setState(() {
                    isAsync = false;
                  });
                  getcaptchawidget(type);
                }
              },
            ),
          ],
        );
      },
    );
  }

//ALERT DIALOG FOR GETTING CAPTCHA
  Future<void> getcaptchawidget(String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Captcha'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      captchaimage,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: MediaQuery.of(context).size.height / 13.6,
                        child: TextField(
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                          ),
                          onChanged: (value) {
                            if (value.isEmpty)
                              return null;
                            else {
                              captchavalue = value;
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                // color: Colors.redAccent,
                                  width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                // color: Colors.redAccent,
                                  width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            ),
                            filled: true,
                            labelStyle: kSubHeaderStyle,
                            labelText: "Captcha text",
                          ),
                        ),
                      ),
                      if (errorcaptcha == true)
                        Text(
                          otpmessage,
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold),
                        )
                    ],
                  ),
                );
              }),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: kButtonText,
              ),
              child: const Text('Regenerate Captcha'),
              onPressed: () {
                Navigator.of(context).pop();
                getaadhaarwidget("oprator");
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: kButtonText,
              ),
              child: const Text('Next'),
              onPressed: () async {
                Navigator.pop(context);
                final uuidno = uuid.v4();
                setState(() {
                  isAsync = true;
                });
                Map<String, dynamic> responsebody =
                await getotp(uuidno, op_aadhar, captchavalue, captchatxnid);

                print(responsebody);

                setState(() {
                  responsebody["message"] == "OTP generation done successfully"
                      ? errorcaptcha = false
                      : errorcaptcha = true;
                  otpmessage = responsebody["message"];
                });
                setState(() {
                  isAsync = false;
                });
                if (errorcaptcha == false) {
                  getotpwidget(op_aadhar , captchavalue,responsebody["txnId"],type);
                } else {
                  getcaptchawidget(type);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getotpwidget( String aadhaar
      ,String captchavalue,String txnid, String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP Sent'),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: OTPTextField(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Open Sans'),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: MediaQuery.of(context).size.width / 10,
                      fieldStyle: FieldStyle.box,
                      onChanged: (pin) {
                        otp = pin;
                        print("Completed: " + pin);
                      },
                      onCompleted: (pin) {
                        otp = pin;
                        print("Completed: " + pin);
                      },
                      otpFieldStyle: OtpFieldStyle(
                          borderColor: Color(0xff333333),
                          focusBorderColor: Color(0xffe06f00)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Next'),
                style: TextButton.styleFrom(
                  primary: kButtonText,
                ),
                onPressed: () async {
                  if (otp.isNotEmpty) {
                    Navigator.pop(context);
                    setState(() {
                      isAsync = true;
                    });
                    Map<String, dynamic> response =
                    await getKYC(aadhaar, otp, txnid);
                    if (response["status"] == "Y") {
                      errorotp=false;
                      final builder = XmlBuilder();
                      builder.element('statelessMatchRequest', nest: () {
                        builder.attribute('language', 'en');
                        builder.attribute(
                            'signedDocument', response["eKycString"]);
                        builder.attribute(
                            'requestId', '850b962e041c11e192340123456789ab');
                      });
                      final bookshelfXml = builder.buildDocument();
                      print(bookshelfXml.toString());
                      try {
                        final result = await platform.invokeMethod(
                            'launchApp2', {'ekyc': bookshelfXml.toXmlString()});
                        XmlDocument xml = XmlDocument.parse(result.toString());
                        setState(() {
                          String errInfo=xml.getElement("statelessMatchResponse").getAttribute('errInfo');
                          facerdmessage = errInfo.toString();
                        });
                        String errCode=xml.getElement("statelessMatchResponse").getAttribute('errCode');
                        //uploading images
                        await captureimage(type,errCode);
                      } on PlatformException catch (e) {
                        print(e);
                      }
                    }
                    else{
                      setState(() {
                        errorotp=true;
                      });
                    }
                    setState(() {
                      isAsync = false;
                    });
                    return;
                  }
                }),
          ],
        );
      },
    );
  }

  Future<void> captureimage(String type,String errCode) async {
    if (errCode == "0") {
      final PickedFile newImage = await pickImageFromCamera(context);
      if (type == "operator" && newImage != null && errCode == "0") {
        setState(() {
          if (newImage != null) {
            operatorImage = File(newImage.path);
            operatorUploaded = true;
          }
        });
      }
      else if (type == "user" && newImage != null && errCode == "0") {
        setState(() {
          if (newImage != null) {
            userImage = File(newImage.path);
            userUploaded = true;
          }
        });
      }
    }
  }
}

//TODO: Improve UI
//Show Error messages
