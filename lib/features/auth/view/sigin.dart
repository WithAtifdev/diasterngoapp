
import 'package:diaster_ngo_app/core/utils/routers/routes_name.dart';
import 'package:diaster_ngo_app/features/auth/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/app_snackbar.dart';
import '../view_model/auth_view_model.dart';
import '../widgets/auth_textfield.dart';


class Signin extends StatefulWidget {
  const Signin({super.key});
  @override
  State<Signin> createState() => _SigninState();
}
class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    return ModalProgressHUD(
      inAsyncCall: vm.loading,
      child: Scaffold(
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
                Center(
                  child: Image.asset(
                    'assets/images/NGO.jpg',
                    height: 200,
                  )),
                const SizedBox(height: 30),
                const Text(
                  'Welcome Back!',
                  style: AppTextStyles.heading,
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        label: 'Email',
                        icon: Icons.email,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        label: 'Password',
                        icon: Icons.lock,
                        controller: passwordController,
                        isPassword: true,
                      ),
                    ],
                  )),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.signup);
                      },
                      child: const Text(
                        'Sign Up',
                        style: AppTextStyles.signUp,
                      )),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.forgotpassword);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: AppTextStyles.forgotPassword,
                      )),
                  ],
                ),
                const SizedBox(height: 250),
                AppButton(
                  width: double.infinity,
                  color: Colors.grey.shade900,
                  text: 'Sign In',
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.signIn(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      if (!context.mounted) return;
                      if (vm.errorMessage != null) {
                        AppSnackBar.error(context, vm.errorMessage!);
                        return;
                      }
                      Navigator.pushReplacementNamed(context,
                        RoutesName.navigationmenu);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}