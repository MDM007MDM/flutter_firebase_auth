import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user;
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber[600],
        elevation: 0,
        centerTitle: true,
        actions: [
          if (_user != null)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _signOut,
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_user != null) {
      return _buildLoggedInContent();
    } else {
      return _buildLoggedOutContent();
    }
  }

  Widget _buildLoggedInContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user, // Changed icon
          color: Colors.amber[400], // Amber icon
          size: 100, // Larger icon
        ),
        const SizedBox(height: 30),
        Text(
          'Welcome, ${_user!.displayName ?? _user!.email ?? "User"}!',
          style: const TextStyle(
            fontSize: 26, // Larger welcome text
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          icon: const Icon(Icons.logout,
              color: Colors.white), // White logout icon
          label: const Text('Sign Out',
              style:
                  TextStyle(fontSize: 18, color: Colors.white)), // White text
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[600], // Amber button
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: _signOut,
        ),
      ],
    );
  }

  Widget _buildLoggedOutContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_circle, // Changed icon
          color: Colors.grey[600], // Grey icon
          size: 100,
        ),
        const SizedBox(height: 30),
        const Text(
          'Hello There!', // Changed welcome text
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          'Please login or create an account to continue.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text('Login', style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.grey[400]!), // Lighter grey border
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/create_account');
          },
          child: const Text('Create Account',
              style:
                  TextStyle(fontSize: 18, color: Colors.white)), // White text
        ),
      ],
    );
  }
}
