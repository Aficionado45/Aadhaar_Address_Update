import 'dart:io';

import 'package:aadhaar_address/screens/capture.dart';
import 'package:aadhaar_address/screens/op_login.dart';
import 'package:aadhaar_address/screens/user_login.dart';
import 'package:aadhaar_address/utils/feedback_form.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:aadhaar_address/screens/editable_form.dart';
import 'package:aadhaar_address/screens/scan.dart';
import 'package:crypto/crypto.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class confirm extends StatefulWidget {
  const confirm();

  @override
  _confirmState createState() => _confirmState();
}

File user_image;
File operator_image;
File document_image;

class _confirmState extends State<confirm> {
  String op_aadhar;
  String user_aadhar;
  String userRef;
  String opRef;
  bool error = false;
  bool error_user = false;
  bool isAsync = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isAsync = true;
    });
    imageLoader();
    setState(() {
      isAsync = false;
    });
  }

  void update() {
    var db = FirebaseFirestore.instance;
    DateTime curr = DateTime.now();

    db.collection("completed").doc(user_aadhar).set(
      {
        "Scanned_Address": address,
        "Updated Address": modifiedAdd,
        "Pincode": pin,
        "User_Aadhaar": user_aadhar,
        "Transation_ID": userRef,
        "Operator_Aadhaar": op_aadhar,
        "Status": "Completed",
        "Timestamp": curr,
      },
    );
    db.collection("ongoing").doc(userRef).delete();
  }

  void imageLoader() async {
    user_image = await retrieveImage('$userRefId/user.png', 'user.png');
    setState(() {});
    operator_image =
        await retrieveImage('$userRefId/operator.png', 'operator.png');
    setState(() {});
    document_image =
        await retrieveImage('$userRefId/document.png', 'document.png');
    setState(() {});
  }

  @override
  Future<File> retrieveImage(String path, String fileName) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    File retrievedImage = File('${appDocDirectory.path}/$fileName');
    try {
      await FirebaseStorage.instance.ref(path).writeToFile(retrievedImage);
    } on FirebaseException catch (err) {
      print(err.toString());
    }
    return retrievedImage;
  }

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
          child: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Address Update Confirmation",
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Transaction ID: $userRefId',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold),
                                ),
                                width: MediaQuery.of(context).size.width * 0.6,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Text(
                                  'Date of update: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold),
                                ),
                                width: MediaQuery.of(context).size.width * 0.6,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Text(
                                  'Time: ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold),
                                ),
                                width: MediaQuery.of(context).size.width * 0.6,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Text(
                                  'Captured Address: $address',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold),
                                ),
                                width: MediaQuery.of(context).size.width * 0.6,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Text(
                                  'Modified Address: $modifiedAdd',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold),
                                ),
                                width: MediaQuery.of(context).size.width * 0.6,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              user_image != null
                                  ? Image(
                                      image: FileImage(
                                        user_image,
                                      ),
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                    )
                                  : Icon(
                                      Icons.downloading_rounded,
                                      color: Color(0xFF143B40),
                                      size:
                                          MediaQuery.of(context).size.width / 5,
                                    ),
                              Text(
                                'User',
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              operator_image != null
                                  ? Image(
                                      image: FileImage(
                                        operator_image,
                                      ),
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                    )
                                  : Icon(
                                      Icons.downloading_rounded,
                                      color: Color(0xFF143B40),
                                      size:
                                          MediaQuery.of(context).size.width / 5,
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Operator',
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              document_image != null
                                  ? Image(
                                      image: FileImage(
                                        document_image,
                                      ),
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                    )
                                  : Icon(
                                      Icons.downloading_rounded,
                                      color: Color(0xFF143B40),
                                      size:
                                          MediaQuery.of(context).size.width / 5,
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Uploaded\nDocument',
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.height / 13.6,
                      child: TextField(
                        // maxLength: 12,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                // color: Colors.redAccent,
                                width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                // color: Colors.redAccent,
                                width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          filled: true,
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          labelText: "Confirm Operator Aadhaar Number",
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.height / 13.6,
                      child: TextField(
                        // maxLength: 12,
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
                            user_aadhar = value;
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                // color: Colors.redAccent,
                                width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                // color: Colors.redAccent,
                                width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          filled: true,
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          labelText: "Confirm User Aadhaar Number",
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF143B40),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          alignment: FractionalOffset.center,
                          width: MediaQuery.of(context).size.width / 4,
                          height: 40,
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                isAsync = false;
                              });
                              Navigator.pushNamed(context, 'scan');
                              //Delete the current document and start a new one at step 1
                            },
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                color: Colors.white,
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
                            color: Color(0xFF143B40),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          alignment: FractionalOffset.center,
                          width: MediaQuery.of(context).size.width / 4,
                          height: 40,
                          child: FlatButton(
                            onPressed: () {
                              if (op_aadhar != null && op_aadhar.length == 12) {
                                var bytes = utf8.encode(op_aadhar);
                                var digest = sha1.convert(bytes);
                                opRef = digest.toString();
                                opRef = opRefId.substring(0, 10);
                                print("Operator Ref ID: $opRef");
                                print("Operator Ref ID: $opRefId");
                              }
                              if (op_aadhar != null && op_aadhar.length == 12) {
                                var bytes = utf8.encode(op_aadhar);
                                var digest = sha1.convert(bytes);
                                userRef = digest.toString();
                                userRef = userRefId.substring(0, 10);
                                print("User Ref ID: $userRef");
                                print("User Ref ID: $userRefId");
                              }

                              if (userRef != userRefId) {
                                setState(() {
                                  error_user = true;
                                  print("error User");
                                });
                              }
                              if (opRef != opRefId) {
                                setState(() {
                                  error = true;
                                  print("error");
                                });
                              }
                              if (userRef == userRefId && opRef == opRefId) {
                                print("Verified");
                                update();
                                setState(() {
                                  error = false;
                                  error_user = false;
                                });
                                setState(() {
                                  isAsync = false;
                                });
                                Navigator.pushNamed(context, 'recipt',
                                    arguments: {
                                      'user_aadhar': user_aadhar,
                                      'op_aadhar': op_aadhar
                                    });
                              }
                            },
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      'Wrong Operator Aadhar Number',
                      style: TextStyle(
                          color: error ? Colors.red : Colors.white,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Wrong User Aadhar Number',
                      style: TextStyle(
                          color: error_user ? Colors.red : Colors.white,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 6),
                      child: Image(
                        image: AssetImage('images/Progress4.png'),
                        // width: MediaQuery.of(context).size.width * 0.67,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
