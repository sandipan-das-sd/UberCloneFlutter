import 'package:demoapp/Widgets/loading_dialouge.dart';
import 'package:demoapp/pages/home_page.dart';

import 'login_scrren.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:demoapp/Methods/common_methods.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController usernameTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  final CommonMethods cMethods = CommonMethods();

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

 Future<void> checkIfNetworkIsAvailable() async {
    await cMethods.checkConnectivity(context);
    signUpFormValidation();
  }


  Future<void> signUpFormValidation() async {
    if (usernameTextEditingController.text.trim().length < 4) {
      cMethods.displaySnackBar(
          "Your Name Must be at least 4 or more characters", context);
    } else if (phoneTextEditingController.text.trim().length != 10) {
      cMethods.displaySnackBar(
          "Your Mobile Number must be equal to 10 digits", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Please write a valid Email", context);
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar(
          "Your password must be at least 6 or more characters", context);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            const LoadingDialog(messageText: "Registering your Account..."),
      );
      try {
        User? userFirebase =
            (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ))
                .user;
        if (userFirebase != null) {
          DatabaseReference userRef = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(userFirebase.uid);
          Map<String, String> userDataMap = {
            'name': usernameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
            "id": userFirebase.uid,
            "blockStatus": "no"
          };
          await userRef.set(userDataMap);
          cMethods.displaySnackBar("Account created successfully!", context);
       Navigator.push(
              context, MaterialPageRoute(builder: (c) => const HomePage()));

        } else {
          cMethods.displaySnackBar("Account creation failed!", context);
        }
      } catch (error) {
        cMethods.displaySnackBar(error.toString(), context);
      } finally {
        Navigator.pop(context); // Close the loading dialog
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset("assets/images/logo.png"),
                const Text(
                  "Create a User Account",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 22),
                TextFormField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    hintText: "example@domain.com",
                    hintStyle: TextStyle(),
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    hintText: "abc_123",
                    hintStyle: TextStyle(),
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneTextEditingController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    hintText: "123-456-7890",
                    hintStyle: TextStyle(),
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    } else if (value.length < 10) {
                      return 'Phone number must be at least 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordTextEditingController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(
                      fontSize: 14,
                    ),
                    hintText: "Enter your password",
                    hintStyle: const TextStyle(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      checkIfNetworkIsAvailable();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                  ),
                  child: const Text("Sign Up"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => const LoginScreen()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Already Have an Account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Login Here",
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.pink,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
