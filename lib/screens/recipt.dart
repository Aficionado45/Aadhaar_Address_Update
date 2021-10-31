import 'package:aadhaar_address/screens/scan.dart';
import 'package:aadhaar_address/screens/user_login.dart';
import 'package:aadhaar_address/utils/constans.dart';
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
                color: kButton,
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
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 6),
                      child: Image(
                        image: AssetImage('images/Progress5.png'),
                        // width: MediaQuery.of(context).size.width * 0.67,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Address Update \nRecipt",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Open Sans",
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 30,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    Divider(),
                    Container(
                      child: Text(
                        'Transaction ID: $userRefId',
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
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
                    Container(
                      child: Text(
                        'Time: ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    Divider(),
                    Container(
                      child: Text(
                        'Resident Aadhaar: ${info['user_aadhar']}',
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
                    Divider(),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              'Captured Address: \n$address',
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold),
                            ),
                            width: MediaQuery.of(context).size.width * 0.6,
                          ),
                          Divider(),
                          Container(
                            child: Text(
                              'Modified Address: \n$modifiedAdd',
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold),
                            ),
                            width: MediaQuery.of(context).size.width * 0.6,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          user_image != null
                              ? Image(
                                  image: FileImage(
                                    user_image,
                                  ),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                )
                              : Icon(
                                  Icons.downloading_rounded,
                                  color: kButton,
                                  size: MediaQuery.of(context).size.width / 5,
                                ),
                          Text(
                            'Resident',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600),
                          ),
                        ]),
                        Column(children: [
                          operator_image != null
                              ? Image(
                                  image: FileImage(
                                    operator_image,
                                  ),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                )
                              : Icon(
                                  Icons.downloading_rounded,
                                  color: kButton,
                                  size: MediaQuery.of(context).size.width / 5,
                                ),
                          Text(
                            'Operator',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600),
                          ),
                        ]),
                        Column(children: [
                          document_image != null
                              ? Image(
                                  image: FileImage(
                                    document_image,
                                  ),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                )
                              : Icon(
                                  Icons.downloading_rounded,
                                  color: kButton,
                                  size: MediaQuery.of(context).size.width / 5,
                                ),
                          Text(
                            'Document',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600),
                          ),
                        ]),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                                await getFeedback(context);
                              },
                              child: Text(
                                "Feedback",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: kButtonText,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          elevation: 20,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffe06f00),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            alignment: FractionalOffset.center,
                            width: MediaQuery.of(context).size.width / 3,
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
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
