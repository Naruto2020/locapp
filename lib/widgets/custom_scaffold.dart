import 'package:flutter/material.dart';

/*static const googleView = LatLng(50.6627, 3.0966);
static const destinationView = LatLng(50.6582, 3.1033);*/

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/images/istockphoto-wellcomes3.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: child!,
          )
        ],
      ),
    );
  }
}
