import 'package:flutter/material.dart';
import 'uKonekMenuPage.dart'; // replace with your actual menu page

class uKonekLoginPage extends StatefulWidget {
  const uKonekLoginPage({super.key});

  @override
  State<uKonekLoginPage> createState() => _uKonekLoginPageState();
}

class _uKonekLoginPageState extends State<uKonekLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // TODO: Replace this with real authentication logic (server / database)
  final String demoUsername = "testuser";
  final String demoPassword = "123456";

  void login() {
    if (_formKey.currentState!.validate()) {
      if (usernameController.text == demoUsername &&
          passwordController.text == demoPassword) {
        // Login successful → navigate to menu and remove previous pages
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const uKonekMenuPage()),
              (route) => false,
        );
      } else {
        // Invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username or password")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "U-KONEK LOGIN",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: login,
                      child: const Text("LOGIN"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}