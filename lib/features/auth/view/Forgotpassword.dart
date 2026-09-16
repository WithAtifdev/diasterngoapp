import 'package:diaster_ngo_app/features/auth/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../view_model/auth_view_model.dart';
import '../widgets/auth_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.black87,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Forgot Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Enter your email to receive reset link',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              Form(
                key: _formKey,

                child: AuthTextField(
                  label: 'Email',
                  icon: Icons.email,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              const SizedBox(height: 30),

              /// SEND RESET LINK BUTTON
              AppButton(
                width: double.infinity,
                color: Colors.grey.shade900,
                text: 'Send Reset Link',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await vm.resetPassword(
                        emailController.text.trim(),
                      );

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reset link sent successfully'),
                        ),
                      );

                      Navigator.pop(context);

                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 20),

              /// BACK BUTTON
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back to Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}