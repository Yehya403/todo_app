import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase_error_codes.dart';
import 'package:todo_app/ui/common/custom_form_field.dart';
import 'package:todo_app/ui/home/home.dart';
import 'package:todo_app/validation_utils.dart';

import '../dialog_utils.dart';
import '../register/register.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'LoginSc';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController(text: 'yehya403@gmail.com');
  var passwordController = TextEditingController(text: '1234567890');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/background_image.png'),
            fit: BoxFit.fill,
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomFormField(
                    controller: emailController,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter full name';
                      }
                      if (!ValidationUtils.isValidEmail(text)) {
                        return 'Please enter valid email';
                      }
                      return null;
                    }),
                CustomFormField(
                    controller: passwordController,
                    hint: 'Password',
                    secureText: true,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter password';
                      }
                      if (text.length < 6) {
                        return 'Password should at least 6 chars';
                      }
                      return null;
                    }),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: const Text('Login')),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RegisterScreen.routeName);
                  },
                  child: const Text('Do not have account ?,Sign Up Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      DialogUtils.showLoading(context, 'Loading...', isCancelable: false);

      await authProvider.login(emailController.text, passwordController.text);

      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(
        context,
        'User successfully logged in',
        posActionTitle: 'OK',
        posAction: () =>
            Navigator.pushReplacementNamed(context, HomeScreen.routeName),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context);
      if (e.code == FirebaseErrorCodes.userNotFound ||
          e.code == FirebaseErrorCodes.wrongPassword ||
          e.code == FirebaseErrorCodes.invalidCredential) {
        DialogUtils.showMessage(
          context,
          'Wrong email or password',
          posActionTitle: 'Try Again',
          isCanceable: false,
        );
      }
    }
  }
}
