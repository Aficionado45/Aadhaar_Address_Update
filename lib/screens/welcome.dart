import 'package:aadhaar_address/utils/constans.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen();

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image(
                    image: AssetImage('images/Aadhaar_Logo.svg'),
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text('Aadhaar Address App',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Zen'
                          // fontFamily: 'Open Sans'
                          )),
                ),
                SizedBox(
                  height: 20,
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
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 40,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'oplogin');
                      },
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                            color: kButtonText,
                            fontSize: MediaQuery.of(context).size.width / 30,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//TODO: Improve UI