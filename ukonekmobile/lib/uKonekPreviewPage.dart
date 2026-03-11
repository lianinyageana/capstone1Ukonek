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
  final String extractedOcrText;

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
    this.extractedOcrText = "",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
            ),
            child: const Center(
              child: Text(
                "REGISTRATION PREVIEW",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Personal Information ---
                    sectionHeader("Personal Information"),
                    previewRow("First Name", firstName),
                    previewRow("Middle Name", middleName),
                    previewRow("Surname", surname),
                    previewRow("Date of Birth", dob),
                    previewRow("Age", age),
                    previewRow("Sex", sex),
                    previewRow("Contact Number", contact),
                    previewRow("Email", email),
                    previewRow("Address", address),

                    const SizedBox(height: 20),

                    // --- Emergency Contact ---
                    sectionHeader("Emergency Contact"),
                    previewRow("Name", emergencyName),
                    previewRow("Contact Number", emergencyContact),
                    previewRow("Relation", relation),

                    const SizedBox(height: 20),

                    // --- ID Section ---
                    sectionHeader("National ID"),

                    if (idImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          idImage!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const Text("No ID image uploaded",
                          style: TextStyle(color: Colors.grey)),

                    const SizedBox(height: 10),

                    // Verification status badge
                    Row(
                      children: [
                        Icon(
                          idVerified
                              ? Icons.verified
                              : Icons.warning_amber_rounded,
                          color: idVerified ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          idVerified ? "ID Verified" : "ID Not Verified",
                          style: TextStyle(
                            color: idVerified ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // --- OCR Extracted Text ---
                    if (extractedOcrText.isNotEmpty) ...[
                      const Text(
                        "📄 Text Read from ID (OCR)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          extractedOcrText,
                          style: const TextStyle(fontSize: 13, height: 1.5),
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "No text could be extracted from the ID image.",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    ],

                    const SizedBox(height: 30),

                    // --- SUBMIT → Navigate to Credentials Page ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
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
                                extractedOcrText: extractedOcrText,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // --- Back Button ---
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("BACK TO EDIT"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D47A1),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget previewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "—",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}