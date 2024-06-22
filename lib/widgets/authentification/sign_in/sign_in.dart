import 'package:deloitte/api_service.dart';
import 'package:deloitte/widgets/authentification/sign_up/sign_up.dart';
import 'package:deloitte/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:deloitte/widgets/button.dart';
import 'package:deloitte/widgets/header.dart';
import 'package:deloitte/widgets/no_account.dart';
import 'package:deloitte/widgets/text_fields.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final regNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  final ApiService apiService = ApiService();

  Future<void> login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      debugPrint("Form is valid");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
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
                    text: 'Please login in order to proceed',
                  ),
                  const SizedBox(height: 50.0),
                  TextFileds(
                    controller: emailController,
                    label: "Email",
                    obscure: false,
                    input: TextInputType.emailAddress,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFileds(
                    controller: regNoController,
                    label: "regNo",
                    obscure: false,
                    input: TextInputType.name,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Register Number';
                      }

                      ///
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFileds(
                    controller: passwordController,
                    label: "Password",
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
                  Button(
                    label: "Log In",
                    onTap: () async {
                      await login(context);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  NoAccount(
                    text1: 'You don\'t have an account ? ',
                    text2: "SignUp",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SignUp(),
                        ),
                      );
                    },
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
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
