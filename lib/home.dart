import 'package:biodata_app/dashboard.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    print('ok');
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      width: double.infinity,
      height: double.infinity,
      child: Center(
          child: Container(
        width: 30.0,
        height: 30.0,
        child: Image.asset(
          'images/logobiodata.png', // Ensure the path matches the location of your image
          fit: BoxFit
              .contain, // Optional: Use BoxFit to control how the image fits
        ),
      )),
    );
  }
}
