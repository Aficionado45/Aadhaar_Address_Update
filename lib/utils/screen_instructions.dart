import 'package:flutter/material.dart';
import 'constans.dart';

Future<void> editScreenInstructions(BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Instructions',
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Open Sans'),
      ),
      content: Container(
        // height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u2022 You may edit the extracted address in a way that is relevant to your usage. However, ensure only minor edits are made.',
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 5,),
                Text(
                  '\u2022 In case the modified address is more than 1km away from the document extracted address, the edit will not be validated.',
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 5,),
                Text(
                  '\u2022 You are required to add your correct PIN code for address updation purposes. In case the PIN code differs from your location by more than 1km, the edit will not be validated.',
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
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
                'Ok',
                style: TextStyle(
                    color: kButtonText, fontFamily: 'Open Sans', fontSize: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> scanScreenInstructions(BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Instructions',
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Open Sans'),
      ),
      content: Container(
        // height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u2022 Ensure that the document is scanned in portrait mode with text vertically oriented for proper OCR extraction.',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 5,),
                Text(
                  '\u2022 In case document isn\'t scanned in the right orientation. Use the rotate feature while scanning, and ensure correct orientation during preview of document.',
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 5,),
                Text(
                  '\u2022 After document scanning, you require to crop it using the \'Crop Document\' feature, so that only the address is visible in the cropped image.',
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 5,),
                Text(
                  '\u2022 If needed, you may crop the scanned document multiple times to extract the address correctly.',
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
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
                'Ok',
                style: TextStyle(
                    color: kButtonText, fontFamily: 'Open Sans', fontSize: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    ),
  );
}