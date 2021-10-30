import 'package:aadhaar_address/screens/user_login.dart';
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
      content: TextField(
        maxLines: 5,
        decoration: InputDecoration(
          filled: true,
          focusColor: Colors.black,
          labelText: 'Feedback/Suggestion/Query',
          labelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Open Sans',
            fontSize: 12,
          ),
          // hintText: 'Enter your feedback/suggestion/query',
        ),
        style: TextStyle(fontFamily: 'Open Sans', fontWeight: FontWeight.bold),
        onChanged: (val) {
          feedback = val;
        },
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF143B40),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          alignment: FractionalOffset.center,
          width: MediaQuery.of(context).size.width / 5,
          height: 40,
          child: FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Open Sans', fontSize: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF143B40),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          alignment: FractionalOffset.center,
          width: MediaQuery.of(context).size.width / 5,
          height: 40,
          child: FlatButton(
            child: Text(
              'Submit',
              style: TextStyle(
                  fontFamily: 'Open Sans', color: Colors.white, fontSize: 12),
            ),
            onPressed: () async {
              if (feedback != '') {
                await submitFeedback(feedback);
              }
              Navigator.pop(context);
            },
          ),
        )
      ],
    ),
  );
}
