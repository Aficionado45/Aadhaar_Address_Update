import 'dart:typed_data';
import 'package:aadhaar_address/screens/user_otp.dart';
import 'package:aadhaar_address/services/authentication_methods.dart';
import 'package:aadhaar_address/utils/constans.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class userLogin extends StatefulWidget {
  const userLogin();

  @override
  _userLoginState createState() => _userLoginState();
}

String userRefId;

class _userLoginState extends State<userLogin> {
  bool error = false;
  Image captchaimage;
  var captchatxnid;
  String otpmessage;
  TextEditingController captchafield = new TextEditingController();
  bool errorcaptcha = false;
  bool isAsync = false;
  @override
  String user_aadhar;

  Future<int> checkIfDocExists(String docId) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('ongoing');
      var doc = await collectionRef.doc(docId).get();
      if (doc.exists) {
        int step = doc.get('step');
        return step;
      } else
        return 0;
    } catch (e) {
      throw e;
    }
  }

  void generateRefID() {
    var bytes = utf8.encode(user_aadhar);
    var digest = sha1.convert(bytes);
    userRefId = digest.toString();
    userRefId = userRefId.substring(0, 10);
    print("User Ref ID: $userRefId");
  }

  void addUser(String id) {
    var db = FirebaseFirestore.instance;
    DateTime curr = DateTime.now();
    db.collection("ongoing").doc(id).set({
      "step": 1,
      "transactionID": id,
      "timestamp": curr,
    });
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
        ),
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: isAsync,
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Image(
                    image: AssetImage('images/Progress0.png'),
                    width: MediaQuery.of(context).size.width * 0.67,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 3 / 26),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Resident Login",
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
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
                        user_aadhar = value;
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
                      labelText: "Resident Aadhaar Number",
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Material(
                  elevation: 20,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kButton,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    alignment: FractionalOffset.center,
                    width: MediaQuery.of(context).size.width / 3,
                    height: 40,
                    child: FlatButton(
                      onPressed: () async {
                        if (user_aadhar != null && user_aadhar.length == 12) {
                          isAsync = true;
                          Map<String, dynamic> responsebody =
                              await getcaptcha();
                          //decoding response
                          setState(() {
                            error = false;
                            var captchaBase64String =
                                responsebody["captchaBase64String"];
                            captchatxnid = responsebody["captchaTxnId"];
                            Uint8List bytes =
                                Base64Decoder().convert(captchaBase64String);
                            captchaimage = Image.memory(bytes);
                          });
                          setState(() {
                            error = false;
                            isAsync = false;
                          });
                        } else {
                          setState(() {
                            error = true;
                            isAsync = false;
                          });
                        }
                      },
                      child: Text(
                        "Get Captcha",
                        style: TextStyle(
                            color: kButtonText,
                            fontSize: MediaQuery.of(context).size.width / 30,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                if (captchaimage != null)
                  Column(
                    children: [
                      captchaimage,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: MediaQuery.of(context).size.height / 13.6,
                        child: TextFormField(
                          controller: captchafield,
                          style: TextStyle(color: Colors.black, fontSize: 16),
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
                            labelStyle: kSubHeaderStyle,
                            labelText: "Enter Captcha",
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Material(
                        elevation: 20,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kButton,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          alignment: FractionalOffset.center,
                          width: MediaQuery.of(context).size.width / 3,
                          height: 40,
                          child: FlatButton(
                            onPressed: () async {
                              final uuidno = uuid.v4();
                              isAsync = true;
                              Map<String, dynamic> responsebody = await getotp(
                                  uuidno,
                                  user_aadhar,
                                  captchafield.text,
                                  captchatxnid);
                              print(responsebody);
                              setState(() {
                                responsebody["message"] ==
                                        "OTP generation done successfully"
                                    ? errorcaptcha = false
                                    : errorcaptcha = true;
                                otpmessage = responsebody["message"];
                                isAsync = false;
                              });
                              if (errorcaptcha == false) {
                                generateRefID();
                                int step = await checkIfDocExists(userRefId);
                                if (step == 0) {
                                  addUser(userRefId);
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => userOTP(
                                        aadharno: user_aadhar,
                                        txnid: responsebody["txnId"],
                                        step: step),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Verify Captcha",
                              style: TextStyle(
                                  color: kButtonText,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 35,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Text(
                  'Please enter a valid 12 digit Aadhaar Number',
                  style: TextStyle(
                      color: error ? Colors.red : Colors.white,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold),
                ),
                if (otpmessage != null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 3 / 26),
                    child: Text(
                      otpmessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: errorcaptcha ? Colors.red : Colors.white,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
