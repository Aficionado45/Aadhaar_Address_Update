import 'package:flutter/material.dart';
import 'constans.dart';

bool validateImage(BuildContext context){

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Face Authentication',
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Open Sans'),
      ),
      content: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Do you wish to authenticate the face captured successfully ?',
            style: TextStyle(
              fontFamily: 'Open Sans',

            ),
          ),
        )
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
                'No',
                style: TextStyle(
                    color: kButtonText, fontFamily: 'Open Sans', fontSize: 12),
              ),
              onPressed: () {
                // return false;
                Navigator.pop(context);
                return false;
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
                'Yes',
                style: TextStyle(
                    fontFamily: 'Open Sans', color: kButtonText, fontSize: 12),
              ),
              onPressed: () async {
                // if (feedback != '') {
                //   await submitFeedback(feedback);
                // }
                Navigator.pop(context);
                return true;
              },
            ),
          ),
        ),
      ],
    ),
  );
}