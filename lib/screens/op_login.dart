import 'dart:typed_data';
import 'package:aadhaar_address/screens/op_otp.dart';
import 'package:aadhaar_address/services/authentication_methods.dart';
import 'package:aadhaar_address/utils/constans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class opLogin extends StatefulWidget {
  const opLogin();

  @override
  _opLoginState createState() => _opLoginState();
}

String opRefId;
var captchatxnid;

class _opLoginState extends State<opLogin> {
  @override
  Image captchaimage;
  String op_aadhar;
  var uuid = Uuid();
  String otpmessage;
  TextEditingController captchafield = new TextEditingController();
  bool isAsync = false;

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('operator');
      var doc = await collectionRef.doc(docId).get();

      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  bool error = false;
  bool errorcaptcha = false;

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
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 3 / 26),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Operator Login",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Open Sans",
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
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
                          bool exists = await checkIfDocExists(op_aadhar);
                          if (op_aadhar != null &&
                              op_aadhar.length == 12 &&
                              exists) {
                            print('Conditions are true.');
                            setState(() {
                              isAsync = true;
                            });
                            Map<String, dynamic> responsebody =
                                await getcaptcha();
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
                            var bytes = utf8.encode(op_aadhar);
                            var digest = sha1.convert(bytes);
                            opRefId = digest.toString();
                            opRefId = opRefId.substring(0, 10);
                            // op_aadhar = null;
                            print("Operator Ref ID: $opRefId");
                          } else {
                            setState(() {
                              error = true;
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            alignment: FractionalOffset.center,
                            width: MediaQuery.of(context).size.width / 3,
                            height: 40,
                            child: FlatButton(
                              onPressed: () async {
                                final uuidno = uuid.v4();
                                setState(() {
                                  isAsync = true;
                                });
                                Map<String, dynamic> responsebody =
                                    await getotp(uuidno, op_aadhar,
                                        captchafield.text, captchatxnid);

                                print(responsebody);
                                setState(() {
                                  responsebody["message"] ==
                                          "OTP generation done successfully"
                                      ? errorcaptcha = false
                                      : errorcaptcha = true;
                                  otpmessage = responsebody["message"];
                                });
                                setState(() {
                                  isAsync = false;
                                });
                                if (errorcaptcha == false)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => opOTP(
                                              aadharno: op_aadhar,
                                              txnid: responsebody["txnId"],
                                            )),
                                  );
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
                          horizontal:
                              MediaQuery.of(context).size.width * 3 / 26),
                      child: Text(
                        otpmessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: errorcaptcha ? Colors.red : Colors.white,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
