import 'package:aadhaar_address/screens/user_login.dart';
import 'package:aadhaar_address/utils/constans.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> submitFeedback(String feedback) async {
  DateTime timestamp = DateTime.now();
  await FirebaseFirestore.instance
      .collection('feedbacks')
      .doc('$userRefId' + '_' + '${timestamp.toString()}')
      .set({
    'reference_id': userRefId,
    'timestamp': timestamp.toString(),
    'feedback': feedback,
  });
}

Future<void> getFeedback(BuildContext context) {
  String feedback = '';

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Raise a Suggestion',
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Open Sans'),
      ),
      content: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: TextField(
          cursorColor: Colors.black,
          maxLines: 5,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kButton),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kButtonText),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            filled: true,
            focusColor: kButtonText,
            labelText: 'Type Here',
            labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Open Sans',
              fontSize: 12,
            ),
          ),
          // hintText: 'Enter your feedback/suggestion/query',
          style:
              TextStyle(fontFamily: 'Open Sans', fontWeight: FontWeight.w500),
          onChanged: (val) {
            feedback = val;
          },
        ),
      ),
      actions: [
        Material(
          elevation: 20,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              color: kButton,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            alignment: FractionalOffset.center,
            width: MediaQuery.of(context).size.width / 5,
            height: 40,
            child: FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: kButtonText, fontFamily: 'Open Sans', fontSize: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
            width: MediaQuery.of(context).size.width / 5,
            height: 40,
            child: FlatButton(
              child: Text(
                'Submit',
                style: TextStyle(
                    fontFamily: 'Open Sans', color: kButtonText, fontSize: 12),
              ),
              onPressed: () async {
                if (feedback != '') {
                  await submitFeedback(feedback);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    ),
  );
}
