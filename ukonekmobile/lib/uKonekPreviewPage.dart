import 'dart:io';
import 'package:flutter/material.dart';
import 'uKonekCredentialPage.dart';

class uKonekPreviewPage extends StatelessWidget {
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

  const uKonekPreviewPage({
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("PERSONAL INFORMATION",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text("Name: $firstName $middleName $surname"),
                    Text("Date of Birth: $dob"),
                    Text("Age: $age"),
                    Text("Contact: $contact"),
                    Text("Sex: $sex"),
                    Text("Email: $email"),
                    Text("Address: $address"),
                    const SizedBox(height: 15),
                    const Text("EMERGENCY CONTACT",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Name: $emergencyName"),
                    Text("Contact: $emergencyContact"),
                    Text("Relation: $relation"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (idImage != null)
                Column(
                  children: [
                    Image.file(
                      idImage!,
                      width: 200,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      idVerified ? "✅ ID Verified" : "⚠️ ID Not Verified",
                      style: TextStyle(
                        color: idVerified ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else
                const Text("No ID selected"),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => uKonekCredentialsPage(
                        firstName: firstName,
                        middleName: middleName,
                        surname: surname,
                        dob: dob,
                        age: age,
                        contact: contact,
                        sex: sex,
                        email: email,
                        address: address,
                        emergencyName: emergencyName,
                        emergencyContact: emergencyContact,
                        relation: relation,
                        idImage: idImage,
                        idVerified: idVerified,
                      ),
                    ),
                  );
                },
                child: const Text("NEXT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}