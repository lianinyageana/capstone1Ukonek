import 'dart:io';
import 'package:flutter/material.dart';
import 'uKonekConsentPage.dart';

class uKonekCredentialsPage extends StatefulWidget {
  final String firstName;
  final String middleName;
  final String surname;
  final String dob;
  final String age;
  final String contact;
  final String sex;
  final String email;
  final String address;
  final String emergencyName;
  final String emergencyContact;
  final String relation;
  final File? idImage;
  final bool idVerified;

  const uKonekCredentialsPage({
    super.key,
    required this.firstName,
    required this.middleName,
    required this.surname,
    required this.dob,
    required this.age,
    required this.contact,
    required this.sex,
    required this.email,
    required this.address,
    required this.emergencyName,
    required this.emergencyContact,
    required this.relation,
    required this.idImage,
    required this.idVerified,
  });

  @override
  State<uKonekCredentialsPage> createState() => _uKonekCredentialsPageState();
}

class _uKonekCredentialsPageState extends State<uKonekCredentialsPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account Credentials")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
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
                  if (value == null || value.isEmpty) return "Username required";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Password required";
                  if (value.length < 6) return "Password must be at least 6 characters";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value != passwordController.text) return "Passwords do not match";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // proceed to consent page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => uKonekConsentPage(
                          firstName: widget.firstName,
                          middleName: widget.middleName,
                          surname: widget.surname,
                          dob: widget.dob,
                          age: widget.age,
                          contact: widget.contact,
                          sex: widget.sex,
                          email: widget.email,
                          address: widget.address,
                          emergencyName: widget.emergencyName,
                          emergencyContact: widget.emergencyContact,
                          relation: widget.relation,
                          idImage: widget.idImage,
                          idVerified: widget.idVerified,
                          username: usernameController.text,
                          password: passwordController.text,
                        ),
                      ),
                    );
                  }
                },
                child: const Text("NEXT"),
              )
            ],
          ),
        ),
      ),
    );
  }
}