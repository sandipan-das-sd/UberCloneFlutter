import 'package:demoapp/Authentication/login_scrren.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController usernameTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

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
                      // Handle signup logic
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
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
                  },
                  child: const Text(
                    "Already Have an Account? Login Here",
                    style: TextStyle(color: Colors.grey),
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
