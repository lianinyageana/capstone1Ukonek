import 'dart:io';
import 'package:flutter/material.dart';

class uKonekConsentPage extends StatelessWidget {
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
  final String username;
  final String password;

  const uKonekConsentPage({
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
    required this.username,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consent & Terms")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: const Text(
                  "By creating an account, you agree to our Terms of Service and Privacy Policy. Please read carefully before proceeding.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Final submission logic here
                // e.g., send data to server or save locally
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Account created successfully!")));
              },
              child: const Text("AGREE & SUBMIT"),
            ),
          ],
        ),
      ),
    );
  }
}