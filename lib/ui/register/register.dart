import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase_error_codes.dart';
import 'package:todo_app/ui/common/custom_form_field.dart';
import 'package:todo_app/ui/dialog_utils.dart';
import 'package:todo_app/validation_utils.dart';
import '../login/login.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'RegisterSc';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var fullNameController = TextEditingController(text: 'Yehya Gamal');

  var userNameController = TextEditingController(text: 'yehya403');

  var emailController = TextEditingController(text: 'yehyagamal84@gmail.com');

  var passwordController = TextEditingController(text: '1234567890');

  var passwordConfirmationController =
      TextEditingController(text: '1234567890');

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
                  controller: fullNameController,
                  hint: 'Full Name',
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please enter full name';
                    }
                    return null;
                  },
                ),
                CustomFormField(
                    controller: userNameController,
                    hint: 'User Name',
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    }),
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
                CustomFormField(
                    controller: passwordConfirmationController,
                    hint: 'Confirm Password',
                    secureText: true,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter password confirmation';
                      }
                      if (passwordController.text != text) {
                        return 'Password does not match';
                      }
                      return null;
                    }),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () {
                      createAccount();
                    },
                    child: const Text('Create Account')),
                const SizedBox(height: 8),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    },
                    child: const Text('Already have an account?')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createAccount() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      DialogUtils.showLoading(context, 'Loading...', isCancelable: false);

      authProvider.register(
        emailController.text,
        passwordController.text,
        fullNameController.text,
        userNameController.text,
      );

      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(
        context,
        'Account successfully created ',
        posActionTitle: 'OK',
        posAction: () =>
            Navigator.pushReplacementNamed(context, LoginScreen.routeName),
        isCanceable: false,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == FirebaseErrorCodes.weakPassword) {
        DialogUtils.showMessage(
          context,
          'The password provided is too weak.',
          negActionTitle: 'Try Again',
          isCanceable: false,
        );
      } else if (e.code == FirebaseErrorCodes.emailAlreadyInUse) {
        DialogUtils.showMessage(
          context,
          'The account already exists for that email.',
          negActionTitle: 'Try Again',
          isCanceable: false,
        );
      }
    } catch (e) {
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(
        context,
        'Something went wrong.',
        negActionTitle: 'Try Again',
        isCanceable: false,
      );
    }
  }
}
