import 'package:aadhaar_address/screens/scan.dart';
import 'package:aadhaar_address/screens/user_login.dart';
import 'package:aadhaar_address/utils/feedback_form.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'confirmation.dart';
import 'editable_form.dart';

class recipt extends StatefulWidget {
  const recipt();

  @override
  _reciptState createState() => _reciptState();
}

class _reciptState extends State<recipt> {
  bool error = false;
  bool isAsync = false;

  @override
  Widget build(BuildContext context) {
    final info =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
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
                          "Address Update Receipt",
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
                                  'User Aadhaar: ${info['user_aadhar']}',
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
                                  'Operator Aadhaar: xxxxxxxx${info['op_aadhar'].substring(8, 12)}',
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
                      height: 10,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              //Share Content
                            },
                            child: Text(
                              "Share",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
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
                              await getFeedback(context);
                            },
                            child: Text(
                              "Give Feedback",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
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
                              Navigator.pushNamed(context, 'welcome');
                            },
                            child: Text(
                              "Finish",
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
                      'Error occured while sharing receipt. Try again',
                      style: TextStyle(
                          color: error ? Colors.red : Colors.white,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold),
                    ),
                    Image(
                      image: AssetImage('images/Progress5.png'),
                      width: MediaQuery.of(context).size.width * 0.67,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 12,
                    )
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

//TODO: Improve UI
//Implement share and feedback option
//Clear all existing variables