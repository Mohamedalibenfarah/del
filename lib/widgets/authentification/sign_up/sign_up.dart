import 'package:deloitte/api_service.dart';
import 'package:deloitte/widgets/authentification/sign_in/sign_in.dart';
import 'package:deloitte/widgets/button.dart';
import 'package:deloitte/widgets/header.dart';
import 'package:deloitte/widgets/no_account.dart';
import 'package:deloitte/widgets/text_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final regNoController = TextEditingController();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String errorMessage = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _signUp();
  }

  final ApiService apiService = ApiService();

 Future<void> _signUp() async {
  if (_formKey.currentState!.validate()) {
    try {
      Map<String, dynamic> result = await apiService.create(
        emailController.text.trim(),
        regNoController.text.trim(),
        passwordController.text.trim(),
        userNameController.text.trim(),
        mobileController.text.trim(),
        nameController.text.trim(),
      );

      // Handle the successful creation
      if (result != null) {
        // Update UI or navigate to another screen
        if (kDebugMode) {
          print('User created successfully: $result');
        }
      } else {
        setState(() {
          errorMessage = 'Failed to create user. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    regNoController.dispose();
    mobileController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Header(
                    text: 'Please create your account in order to be able to benefit from our service!',
                  ),
                  const SizedBox(height: 20.0),

                  TextFileds(
                    controller: regNoController,
                    label: 'RegNo',
                    obscure: false,
                    input: TextInputType.text,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your RegNo';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),
                  TextFileds(
                    controller: nameController,
                    label: 'Name',
                    obscure: false,
                    input: TextInputType.text,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Name';
                      }
                      return null;
                    },
                  ),
                   TextFileds(
                    controller: userNameController,
                    label: 'User Name',
                    obscure: false,
                    input: TextInputType.text,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your User  Name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),
                  TextFileds(
                    controller: emailController,
                    label: 'Email',
                    obscure: false,
                    input: TextInputType.emailAddress,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),

                  /// TextField pour le mot de passe
                  TextFileds(
                    controller: passwordController,
                    label: 'Password',
                    obscure: true,
                    input: TextInputType.visiblePassword,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFileds(
                    controller: mobileController,
                    label: 'Mobile Number',
                    obscure: false,
                    input: TextInputType.number,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Mobile Number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20.0),
                  Button(
                    label: "Sign Up",
                    onTap: _signUp,
                  ),
                  const SizedBox(height: 10.0),
                  NoAccount(
                    text1: 'You  have an account ? ',
                    text2: "LogIn",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SignIn(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
