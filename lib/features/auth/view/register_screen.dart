
import 'package:diaster_ngo_app/features/auth/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/auth_view_model.dart';

import '../widgets/auth_textfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
            vertical: 30,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: Image.asset(
                  'assets/images/NGO.jpg',
                  height: 150,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Form(
                key: _formKey,

                child: Column(
                  children: [

                    /// FULL NAME
                    AuthTextField(
                      label: 'Full Name',
                      icon: Icons.person,
                      controller: nameController,
                    ),

                    const SizedBox(height: 15),

                    /// EMAIL
                    AuthTextField(
                      label: 'Email',
                      icon: Icons.email,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 15),

                    /// PASSWORD
                    AuthTextField(
                      label: 'Password',
                      icon: Icons.lock,
                      controller: passwordController,
                      isPassword: true,
                    ),

                    const SizedBox(height: 15),

                    /// CONFIRM PASSWORD
                    AuthTextField(
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      controller: confirmPasswordController,
                      isPassword: true,

                      validator: (value) {

                        if (value == null || value.isEmpty) {
                          return 'Confirm Password is required';
                        }

                        if (value != passwordController.text) {
                          return "Passwords don't match";
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// SIGN UP BUTTON
              AppButton(
                width: double.infinity,
                color: Colors.grey.shade900,
                text: 'Sign Up',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await vm.signUp(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Signup Successful'),
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

              /// SIGN IN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 5),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}