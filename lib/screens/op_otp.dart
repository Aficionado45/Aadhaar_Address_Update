import 'package:aadhaar_address/screens/op_login.dart';
import 'package:aadhaar_address/services/authentication_methods.dart';
import 'package:aadhaar_address/utils/constans.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class opOTP extends StatefulWidget {
  const opOTP({this.txnid, this.aadharno});

  final String txnid, aadharno;

  @override
  _opOTPState createState() => _opOTPState();
}

class _opOTPState extends State<opOTP> {
  @override
  String otp;
  bool error = false;
  bool isAsync = false;

  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 4 / 28),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Verify OTP",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(50),
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
              Material(
                elevation: 20,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                    color: kButton,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  alignment: FractionalOffset.center,
                  width: MediaQuery.of(context).size.width / 3.0,
                  height: 40,
                  child: FlatButton(
                    onPressed: () async {
                      if (otp.isNotEmpty) {
                        setState(() {
                          error = false;
                          isAsync = true;
                        });
                        bool isValidated = await validateOTP(
                            widget.aadharno, otp, widget.txnid);
                        print(isValidated);
                        if (isValidated) {
                          setState(() {
                            isAsync = false;
                          });
                          Navigator.pushNamed(context, 'userlogin');
                        } else {
                          setState(() {
                            error = true;
                            isAsync = false;
                          });
                        }
                      } else {
                        setState(() {
                          error = true;
                          isAsync = false;
                        });
                      }
                    },
                    child: Text(
                      "Enter OTP",
                      style: TextStyle(
                          color: kButtonText,
                          fontSize: MediaQuery.of(context).size.width / 30,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Invalid OTP',
                style: TextStyle(
                    color: error ? Colors.red : Colors.white,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 12,
              )
            ],
          ),
        ),
      ),
    );
  }
}

//TODO: Improve UI
//Error for wrong otp and resend option
////API integration
