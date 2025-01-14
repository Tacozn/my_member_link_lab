
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link_lab/myconfig.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  double passwordStrength = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/metlo.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  "Create an Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign up to get started",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Your Email",
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  controller: passwordcontroller,
                  onChanged: (value) {
                    setState(() {
                      passwordStrength = calculatePasswordStrength(value);
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Your Password",
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Password Strength Indicator
                LinearProgressIndicator(
                  value: passwordStrength,
                  backgroundColor: Colors.grey[300],
                  color: passwordStrength > 0.7 ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 8),
                
                TextField(
                  obscureText: true,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Confirm Password",
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  elevation: 5,
                  onPressed: onRegisterDialog,
                  minWidth: double.infinity,
                  height: 50,
                  color: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Already registered? Login",
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Quick Links for Help and Support
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => _launchURL('https://example.com/faq'),
                      child: Text(
                        "FAQ",
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _launchURL('https://example.com/live-chat'),
                      child: Text(
                        "Live Chat",
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _launchURL('https://example.com/help-center'),
                      child: Text(
                        "Help Center",
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to open URLs
  void _launchURL(String url) async {
    if (!await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Email validation method
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(email);
  }

  // Password strength calculation method
  double calculatePasswordStrength(String password) {
    double strength = 0.0;
    
    // Check for minimum length
    if (password.length >= 8) strength += 0.25;
    if (password.length >= 12) strength += 0.25;

    // Check for character variety
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.15; // Uppercase letters
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.15; // Lowercase letters
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.15; // Numbers
    if (password.contains(RegExp(r'[!@#\$&*~]'))) strength += 0.2; // Special characters

    // Limit strength to 1.0 (100%)
    return strength.clamp(0.0, 1.0);
  }

  void onRegisterDialog() {
    String email = emailcontroller.text;
    String password = passwordcontroller.text;
    String confirmPassword = confirmPasswordController.text;
    
    // Check if email and password fields are filled
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and both password fields"),
      ));
      return;
    }

    // Validate email format
    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid email address"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to create a new account?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                userRegistration();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void userRegistration() {
    String email = emailcontroller.text;
    String pass = passwordcontroller.text;
    http.post(
      Uri.parse("${MyConfig.servername}/memberlink/api/register_user.php"),
      body: {"email": email, "password": pass},
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.pop(context); // Go back to login screen after successful registration
        } else if (data['data'] == "Email already exists") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Email already exists"),
            backgroundColor: Colors.red,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Server Error"),
          backgroundColor: Colors.red,
        ));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred"),
        backgroundColor: Colors.red,
      ));
    });
  }
}




