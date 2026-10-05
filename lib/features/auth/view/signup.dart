
import 'package:diaster_ngo_app/features/auth/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
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
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 25),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthTextField(
                      label: 'Full Name',
                      icon: Icons.person,
                      controller: nameController,
                    ),
                    const SizedBox(height: 15),
                    AuthTextField(
                      label: 'Email',
                      icon: Icons.email,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    AuthTextField(
                      label: 'Password',
                      icon: Icons.lock,
                      controller: passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 15),
                    AuthTextField(
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      controller: confirmPasswordController,
                      isPassword: true,
                      validator: (value) {
                        return Validators.validateConfirmPassword(
                          value,
                          passwordController.text,
                        );
                      }),
                  ],
                )),
              const SizedBox(height: 30),
              AppButton(
                width: double.infinity,
                color: Colors.grey.shade900,
                text: 'Sign Up',
                onTap: () async {
                  if (!_formKey.currentState!.validate()) return;
                  await vm.signUp(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                   if (!context.mounted) return;
                  if (vm.errorMessage != null) {
                    AppSnackBar.error(context,vm.errorMessage!);
                    return;
                  }
                  AppSnackBar.success(
                    context, 'Signup Successful');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
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
                      style: AppTextStyles.signIn,
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