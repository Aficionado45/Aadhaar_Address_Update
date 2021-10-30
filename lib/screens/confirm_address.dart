import 'package:aadhaar_address/screens/editable_form.dart';
import 'package:aadhaar_address/services/locationmethods.dart';
import 'package:aadhaar_address/utils/feedback_form.dart';
import 'package:flutter/material.dart';
import 'package:aadhaar_address/utils/constans.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

enum AppState { free, comparedlocation, unsuccessful }

class cnfrmAddress extends StatefulWidget {
  const cnfrmAddress({this.address});

  final String address;

  @override
  _cnfrmAddressState createState() => _cnfrmAddressState();
}

class _cnfrmAddressState extends State<cnfrmAddress> {
  AppState state = AppState.free;
  double _distanceinmeters;
  bool isAsync = false;

  TextEditingController script = TextEditingController();
  void initState() {
    super.initState();
    script.text = widget.address;
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
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Document Extracted Address", style: kHeaderStyle),
                    Text(
                      "Confirm With Current GPS Location",
                      style: kHeaderStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: script,
                      minLines: 5,
                      maxLines: 100,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (val) {
                        setState(() {});
                      },
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF143B40),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          alignment: FractionalOffset.center,
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 40,
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                isAsync = false;
                              });
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, 'scan');
                            },
                            child: Text(
                              "Scan Again",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        if (state == AppState.free)
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF143B40),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            alignment: FractionalOffset.center,
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 40,
                            child: FlatButton(
                              onPressed: () async {
                                setState(() {
                                  isAsync = true;
                                });
                                _distanceinmeters =
                                    await getlocation(widget.address);
                                print(_distanceinmeters);
                                setState(() {
                                  state = _distanceinmeters > 300
                                      ? AppState.unsuccessful
                                      : AppState.comparedlocation;
                                  isAsync = false;
                                });
                              },
                              child: Text(
                                "Get Location",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        if (state == AppState.comparedlocation)
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF143B40),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            alignment: FractionalOffset.center,
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 40,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  isAsync = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        editForm(address: widget.address),
                                  ),
                                );
                              },
                              child: Text(
                                "Confirm Address",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_distanceinmeters != null)
                      Text(
                        "Discrepancy: $_distanceinmeters meters",
                        textAlign: TextAlign.center,
                      ),
                    if (state == AppState.unsuccessful)
                      Text(
                        "The Distance between the address extracted from OCR and the address otained from GPS is more than 300 metres. Reset and scan again",
                        textAlign: TextAlign.center,
                      ),
                    if (state == AppState.comparedlocation)
                      Text(
                        "Location verified using GPS. Now you can confirm the address and proceed",
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3.5,
                    ),
                    Image(
                      image: AssetImage('images/Progress2.png'),
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
//Show OCR Result with scanned address and cropped document image
//Verify extracted location with GPS location in a limit of 300m
//Show Error on wrong location verification
//User will be given a countdown of 1 min to press confirm or reset
//If user confirms store scanned image in storage and update the ongoing document step, timestamp, pincode and scanned_address field
