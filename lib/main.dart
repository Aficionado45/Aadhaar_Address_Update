import 'package:aadhaar_address/screens/biometric.dart';
import 'package:aadhaar_address/screens/recipt.dart';
import 'package:aadhaar_address/utils/constans.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome.dart';
import 'screens/op_login.dart';
import 'screens/op_otp.dart';
import 'screens/scan.dart';
import 'screens/user_login.dart';
import 'screens/user_otp.dart';
import 'screens/capture.dart';
import 'screens/confirm_address.dart';
import 'screens/confirmation.dart';
import 'screens/editable_form.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aadhar Address Update",
      initialRoute: 'welcome',
      routes: {
        'welcome': (context) => WelcomeScreen(),
        'oplogin': (context) => opLogin(),
        'opotp': (context) => opOTP(),
        'userotp': (context) => userOTP(),
        'userlogin': (context) => userLogin(),
        'scan': (context) => scanDoc(),
        'confirm': (context) => confirm(),
        'capture': (context) => capture(),
        'form': (context) => editForm(),
        'confirmaddress': (context) => cnfrmAddress(),
        'recipt': (context) => recipt(),
        'biometric': (context) => biometric(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          dividerTheme: DividerThemeData(color: kButton, thickness: 2)),
    );
  }
}
