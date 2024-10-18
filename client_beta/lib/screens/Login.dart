// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(16.0), // Add some padding for better layout
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to the Login Page!'),
              SizedBox(height: 20),

              // Username Input
              Container(
                width: 300, // Set the width of the TextField
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7), // Rounded corners
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Password Input
              Container(
                width: 300, // Set the width of the TextField
                child: TextField(
                  obscureText: true, // This hides the input text
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7), // Rounded corners
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Login'), // Changed to 'Login' for clarity
              ),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/testdata');
                },
                child: Text('Test Data'), // Changed to 'Login' for clarity
              ),
              SizedBox(height: 10),

              // Optionally, a button for registration
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
