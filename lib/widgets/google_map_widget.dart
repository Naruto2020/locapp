//import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:locapp/services/geolocation_services.dart';
import 'package:location/location.dart';
import '../screens/trip_form_screen.dart';


class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key, this.child, this.destLat, this.destLon});
  final Widget? child;
  final double? destLat;
  final double? destLon;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {

  Location _locationController = new Location();

  //static const googlePlex = LatLng(50.6627, 3.0966);
  static const destinationView = LatLng(50.6627, 3.0966);

  late LatLng destinationPosition;
  LatLng? currentPosition = null;

  late DateTime now;
  late String formattedDateTime;
  late Timer _timer;


  // init state and get user geolocation
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Formater la date et l'heure dans un format spécifique
    formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    getLocationUpdates();
    destinationPosition = LatLng(
        widget.destLat ?? destinationView.latitude,
        widget.destLon ?? destinationView.longitude
    );

    // Initialiser et démarrer le Timer pour envoyer la localisation du user en BDD  toutes les 2 minutes
    _timer = Timer.periodic(Duration(minutes: 2), (timer) {
      if (currentPosition != null) {
        userLocation();
      }
    });

  }


  void userLocation() async {
    //if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
    var regBody = {
      "latitude" : currentPosition?.latitude,
      "longitude": currentPosition?.longitude,
      "timestamp" : formattedDateTime,
    };
    try {
      final responseData = await GeolocationServices.postUserGeolocation('/geolocation/create', regBody);
      //print(responseData);
    } catch (e) {
      throw Exception('Error: $e');
    }
    //}
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPosition == null ? const Center(
        child: Text("Loading...")
      ) : GoogleMap(
          initialCameraPosition: CameraPosition(
            target: currentPosition!,
            zoom: 13
          ),
          markers: {
             Marker(
              markerId: const MarkerId("_currentLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: currentPosition!,
            ),
             Marker(
              markerId: const MarkerId("_destinationPosition"),
              icon: BitmapDescriptor.defaultMarker,
              position: destinationPosition,
            )
          },
      ),
    );
  }


  Future<void> getLocationUpdates() async {
    bool _serviceEnable;
    PermissionStatus _permissionGranted;

    _serviceEnable = await _locationController.serviceEnabled();
    if(_serviceEnable) {
      _serviceEnable = (await _locationController.requestPermission()) as bool;
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if(_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if(_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen(
          (LocationData currentLocation) {
            if(currentLocation.latitude != null &&
               currentLocation.longitude != null) {
              setState(() {
                // user device position
                currentPosition = LatLng(currentLocation.latitude!, currentLocation.latitude!);
                print(currentPosition);
              });
            }
          });
  }
}

