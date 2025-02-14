import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark Grey Background
      appBar: AppBar(
        title:
            const Text('Create Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber[600], // Amber AppBar
        elevation: 0,
        centerTitle: true, // Center the title
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        // Center the body content
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0), // Increased padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Join Us!',
                style: TextStyle(
                  fontSize: 32, // Larger title
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10), // Reduced subtitle spacing
              const Text(
                'Create an account to get started',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey, // Lighter grey subtitle
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40), // Increased spacing before fields
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'your.email@example.com',
                  labelStyle:
                      TextStyle(color: Colors.grey[400]), // Lighter label
                  hintStyle:
                      TextStyle(color: Colors.grey[600]), // Even lighter hint
                  prefixIcon:
                      Icon(Icons.email, color: Colors.amber[400]), // Amber icon
                  filled: true,
                  fillColor: Colors.grey[850], // Darker grey fill
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Less rounded
                    borderSide: BorderSide.none, // No border
                  ),
                  focusedBorder: OutlineInputBorder(
                    // Focused state border
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        color: Colors.amber[400]!), // Amber focus border
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.lock, color: Colors.amber[400]),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.amber[400]!),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon:
                      Icon(Icons.lock_outline, color: Colors.amber[400]),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.amber[400]!),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Increased spacing before button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600], // Amber button
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0), // Slightly larger button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Less rounded button
                  ),
                ),
                onPressed: () {
                  _createAccount(context);
                },
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[400], // Lighter grey text button
                ),
                child: const Text(
                  'Already have an account? Sign In',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createAccount(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog(context, "Please fill in all fields.");
      return;
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      _showErrorDialog(context, "Invalid email format.");
      return;
    }

    if (password.length < 6) {
      _showErrorDialog(context, "Password must be at least 6 characters.");
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog(context, "Passwords do not match.");
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
                color: Colors.amber), // Amber loading indicator
          );
        },
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context).pop();
      _showSuccessDialog(context);
    } on FirebaseAuthException catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      String errorMessage = "An error occurred.";

      if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid.";
      } else if (e.code == 'operation-not-allowed') {
        errorMessage =
            "Email/password accounts are not enabled. Enable them in the Firebase console.";
      }

      _showErrorDialog(context, errorMessage);
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorDialog(
          context, "An unexpected error occurred: ${e.toString()}");
      print(e);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800], // Darker dialog background
          title: Text("Error",
              style: TextStyle(color: Colors.amber[400])), // Amber error title
          content: Text(message,
              style: const TextStyle(color: Colors.white)), // White content
          actions: <Widget>[
            TextButton(
              child: Text("OK",
                  style:
                      TextStyle(color: Colors.amber[400])), // Amber OK button
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text("Success", style: TextStyle(color: Colors.amber[400])),
          content: const Text("Account created successfully!",
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text("OK", style: TextStyle(color: Colors.amber[400])),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}
