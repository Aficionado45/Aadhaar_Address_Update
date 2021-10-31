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
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: Image(
                        image: AssetImage('images/Progress1.png'),
                        width: MediaQuery.of(context).size.width * 0.67,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Confirm Address With Current GPS Location",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Open Sans",
                            fontWeight: FontWeight.w600),
                      ),
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
                        labelText: 'Updated Address',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Open Sans',
                          fontSize: 15,
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
                            color: kButton,
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
                                color: kButtonText,
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
                              color: Color(0xffe06f00),
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
                                  state = _distanceinmeters > 1000
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
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_distanceinmeters != null)
                      Text(
                        "Discrepancy: $_distanceinmeters meters",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (state == AppState.unsuccessful)
                      Text(
                        "The Distance between the address extracted from OCR and the address otained from GPS is more than 900 metres. Reset and scan again",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                    if (state == AppState.comparedlocation)
                      Text(
                        "Location verified using GPS. Now you can confirm the address and proceed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
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
