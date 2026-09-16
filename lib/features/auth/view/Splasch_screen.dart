
import 'package:diaster_ngo_app/features/auth/view/auth_wrapper.dart';
import 'package:flutter/material.dart';


class Splaschscreen extends StatefulWidget {
  const Splaschscreen({super.key});

  @override
  State<Splaschscreen> createState() => _SplaschscreenState();
}

class _SplaschscreenState extends State<Splaschscreen> {

  @override
  void initState() {
    super.initState();
_goNext();
  }
  
  void _goNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/NGO.jpg',
              height: 250,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Disaster & NGO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}