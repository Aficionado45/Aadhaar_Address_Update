import 'package:aadhaar_address/utils/constans.dart';
import 'package:aadhaar_address/utils/feedback_form.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class biometric extends StatefulWidget {
  const biometric();

  @override
  _biometricState createState() => _biometricState();
}

class _biometricState extends State<biometric> {
  bool error = false;
  bool userUploaded = false;
  bool operatorUploaded = false;

  Future getFingerprint() async {
    // LocalAuthentication localAuth = new LocalAuthentication();
    // bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    // if (canCheckBiometrics) {
    //   // List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
    //   bool isAuthenticated = await localAuth.authenticate(
    //       localizedReason: 'Provide fingerprint', biometricOnly: true);
    // }
  }

  @override
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
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              "Biometric Verification",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Open Sans'),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.fingerprint_rounded,
                      color: userUploaded ? Colors.green : Color(0xFF143B40),
                      size: MediaQuery.of(context).size.height / 4,
                    ),
                    Text(
                      'User',
                      style: TextStyle(
                          fontFamily: 'Open Sans', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: IconButton(
                        onPressed: () async {
                          await getFingerprint();
                        },
                        icon: Icon(
                          Icons.present_to_all_rounded,
                          color: Color(0xFF143B40),
                        ),
                        iconSize: MediaQuery.of(context).size.height / 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.fingerprint_rounded,
                      color:
                          operatorUploaded ? Colors.green : Color(0xFF143B40),
                      size: MediaQuery.of(context).size.height / 4,
                    ),
                    Text(
                      'Operator',
                      style: TextStyle(
                          fontFamily: 'Open Sans', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: IconButton(
                        onPressed: () async {
                          await getFingerprint();
                        },
                        icon: Icon(
                          Icons.present_to_all_rounded,
                          color: Color(0xFF143B40),
                        ),
                        iconSize: MediaQuery.of(context).size.height / 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
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
                onPressed: () async {},
                child: Text(
                  "Verify",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Spacer(),
            Text(
              'Please capture both fingerprints',
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
    );
  }
}

//API Integration
//Improve UI
//On failure error messages and on success shift the document from ongoing to completed