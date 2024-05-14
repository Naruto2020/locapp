import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/trip_services.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/google_map_widget.dart';
import '../widgets/notification_widget.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TripFormScreen extends StatefulWidget {
  const TripFormScreen({super.key, this.token,});
  final token;

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final GlobalKey<FormState> _formTripKey = GlobalKey<FormState>();
  String? userDestinationPosition;

  final TextEditingController _departureTimeController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();
  final TextEditingController _departureAddressController = TextEditingController();
  final TextEditingController _destinationAddressController = TextEditingController();
  final TextEditingController _departureLatController = TextEditingController();
  final TextEditingController _departureLngController = TextEditingController();
  final TextEditingController _destinationLatController = TextEditingController();
  final TextEditingController _destinationLngController = TextEditingController();

  void postTrip() async {
    if(
    _departureTimeController.text.isNotEmpty && _arrivalTimeController.text.isNotEmpty
    && _departureAddressController.text.isNotEmpty && _destinationAddressController.text.isNotEmpty
    && _departureLatController.text.isNotEmpty && _departureLngController.text.isNotEmpty
    && _destinationLatController.text.isNotEmpty && _destinationLngController.text.isNotEmpty
    ) {

      var regBody = {
        "departureTime" : _departureTimeController.text,
        "arrivalTime": _arrivalTimeController.text,
        "departureAddress" : _departureAddressController.text,
        "destinationAddress" : _destinationAddressController.text,
        "departureLat" : _departureLatController.text,
        "departureLng" : _departureLngController.text,
        "destinationLng": _destinationLatController.text,
        "destinationLat": _destinationLngController.text
      };
      try {
        final responseData = await TripServices.createTrip('/travel/create-travel', regBody);
        /*if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        }*/
      } catch (e) {
        throw Exception('Error: $e');
      }
    }
  }


  @override
  void initState() {
    super.initState();
    _arrivalTimeController.text = ""; // Initialiser à une chaîne vide
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),*/
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Planifier votre trajet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _formTripKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GoogleMapWidget(
                      destLat: double.tryParse(_destinationLatController.text)?? 0,
                      destLon: double.tryParse(_destinationLngController.text) ?? 0,), // Affichage de la carte Google Maps et recupération des coordonnée de la destination user
                  ),
                  const SizedBox(height: 20),
                  const Expanded(child: NotificationWidget()),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _departureTimeController,
                          readOnly: true,
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );

                            if (selectedDate != null) {
                              final selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (selectedTime != null) {
                                setState(() {
                                  _departureTimeController.text =
                                  '${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ${selectedTime.hour}:${selectedTime.minute}';
                                });
                              }
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Date et heure de départ',
                            hintText: 'Sélectionner la date et l\'heure',
                            hintStyle: TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _arrivalTimeController,
                          enabled: false, // Masque le champ de texte
                          decoration: const InputDecoration(labelText: 'Arrival Time'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter arrival time';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _departureAddressController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter departure address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Adresse de départ'),
                            hintText: 'Adresse  départ',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _destinationAddressController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter destination address';
                            }
                            return null;
                          },

                          decoration: InputDecoration(
                            label: const Text('Adresse de destination'),
                            hintText: 'Adresse de destination',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _departureLatController,
                          decoration: const InputDecoration(labelText: 'Departure Latitude'),
                          enabled: false, // Masque le champ de texte
                          /*validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter departure latitude';
                            }
                            return null;
                          },*/
                        ),
                        TextFormField(
                          controller: _departureLngController,
                          decoration: const InputDecoration(labelText: 'Departure Longitude'),
                          enabled: false, // Masque le champ de texte
                          /*validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter departure latitude';
                            }
                            return null;
                          },*/
                        ),
                        TextFormField(
                          controller: _destinationLatController,
                          decoration: const InputDecoration(labelText: 'Destination Latitude'),
                          enabled: false, // Masque le champ de texte
                          /*validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter departure latitude';
                            }
                            return null;
                          },*/
                        ),
                        TextFormField(
                          controller: _destinationLngController,
                          decoration: const InputDecoration(labelText: 'Destination Longitude'),
                          enabled: false, // Masque le champ de texte
                          /*validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter departure latitude';
                            }
                            return null;
                          },*/
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formTripKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Traitement des données'),
                                ),
                              );
                              postTrip();
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




