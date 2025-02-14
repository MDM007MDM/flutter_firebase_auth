import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Forgot Password',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber[600],
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              const Icon(
                Icons.lock_reset_outlined,
                color: Colors.amber,
                size: 80, // Larger icon
              ),
              const SizedBox(height: 20),
              const Text(
                'Trouble Logging In?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your email and we'll send you a password reset link.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'your.email@example.com',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.email, color: Colors.amber[400]),
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
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  _resetPassword(context);
                },
                child: const Text(
                  'Send Reset Link',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to previous screen (login)
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[400],
                ),
                child: const Text(
                  'Back to Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showErrorDialog(context, "Please enter your email.");
      return;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      _showErrorDialog(context, "Invalid email format.");
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        },
      );

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Navigator.of(context).pop();

      _showSuccessDialog(
          context, "Password reset email sent. Check your inbox.");
    } on FirebaseAuthException catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      String errorMessage = "An error occurred.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email you enter is invalid';
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
          backgroundColor: Colors.grey[800],
          title: Text("Error", style: TextStyle(color: Colors.amber[400])),
          content: Text(message, style: const TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text("OK", style: TextStyle(color: Colors.amber[400])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text("Success", style: TextStyle(color: Colors.amber[400])),
          content: Text(message, style: const TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text("OK", style: TextStyle(color: Colors.amber[400])),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Pop twice to go back to login
              },
            ),
          ],
        );
      },
    );
  }
}
