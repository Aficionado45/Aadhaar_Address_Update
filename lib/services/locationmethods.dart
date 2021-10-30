// Get current coordinates of the user
import 'dart:math';

import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

LocationData _currentPosition;
Location location = Location();

Future<double> getlocation(String address) async {
  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;
  // _serviceEnabled = await location.serviceEnabled();
  // if (!_serviceEnabled) {
  //   _serviceEnabled = await location.requestService();
  //   if (!_serviceEnabled) {
  //     return;
  //   }
  // }
  // _permissionGranted = await location.hasPermission();
  // if (_permissionGranted == PermissionStatus.denied) {
  //   _permissionGranted = await location.requestPermission();
  //   if (_permissionGranted != PermissionStatus.granted) {
  //     return;
  //   }
  // }
  // _currentPosition = await location.getLocation();
  // var value = await _getCoordsFromAddress(
  //     _currentPosition.latitude, _currentPosition.longitude, address);
  // double distance = comparecoordinates(_currentPosition.latitude,
  //     _currentPosition.longitude, value.latitude, value.longitude);
  // print(distance);
  // return distance;


  //For testing
  return 100.00;
}

Future<Coordinates> _getCoordsFromAddress(
    double lat, double lang, String address) async {
  var addresses = await Geocoder.local.findAddressesFromQuery(address);
  var first = addresses.first;
  // ${first.featureName}
  return first.coordinates;
}

double comparecoordinates(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)) * 1000;
}
