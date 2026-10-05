
import 'package:diaster_ngo_app/core/utils/routers/routes_name.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';

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
    Navigator.pushReplacementNamed(context, RoutesName.authwrapper);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
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
              style: AppTextStyles.heading,
            ),
          ],
        ),
      ),
    );
  }
}