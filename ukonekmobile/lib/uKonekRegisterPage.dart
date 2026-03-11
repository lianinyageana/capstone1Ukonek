import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:string_similarity/string_similarity.dart';
import 'uKonekPreviewPage.dart';

class uKonekRegisterPage extends StatefulWidget {
  const uKonekRegisterPage({super.key});

  @override
  State<uKonekRegisterPage> createState() => _uKonekRegisterPageState();
}

class _uKonekRegisterPageState extends State<uKonekRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final surnameController = TextEditingController();
  final ageController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final emergencyNameController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final relationController = TextEditingController();

  DateTime? selectedDate;
  String selectedSex = "Male";
  File? _idImage;
  bool _idVerified = false;
  bool _isVerifying = false;

  // Stores the raw OCR text extracted from the ID image
  String _extractedOcrText = "";

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        int age = DateTime.now().year - picked.year;
        if (DateTime.now().month < picked.month ||
            (DateTime.now().month == picked.month &&
                DateTime.now().day < picked.day)) {
          age--;
        }
        ageController.text = age.toString();
      });
    }
  }

  Future<void> pickIDImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _idImage = File(pickedFile.path);
        _idVerified = false;
        _extractedOcrText = "";
      });
      await verifyID();
    }
  }

  Future<void> verifyID() async {
    if (_idImage == null) return;

    setState(() => _isVerifying = true);

    final inputImage = InputImage.fromFile(_idImage!);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    // Store the raw OCR text for preview
    final rawText = recognizedText.text.trim();

    String normalize(String s) =>
        s.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');

    String ocrText = normalize(rawText);
    String fullNameText = normalize(
        "${firstNameController.text} ${middleNameController.text} ${surnameController.text}");
    String shortNameText =
    normalize("${firstNameController.text} ${surnameController.text}");

    double fullSimilarity =
    StringSimilarity.compareTwoStrings(ocrText, fullNameText);
    double shortSimilarity =
    StringSimilarity.compareTwoStrings(ocrText, shortNameText);

    bool matches = fullSimilarity > 0.55 || shortSimilarity > 0.55;

    setState(() {
      _idVerified = matches;
      _extractedOcrText = rawText;
      _isVerifying = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          matches ? "✅ ID verified" : "⚠️ ID may not match. Please verify."),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                "U-KONEK REGISTRATION",
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField("First Name", firstNameController),
                      buildTextField("Middle Name", middleNameController),
                      buildTextField("Surname", surnameController),
                      GestureDetector(
                        onTap: pickDate,
                        child: AbsorbPointer(
                            child: buildTextField(
                                "Date of Birth",
                                TextEditingController(
                                    text: selectedDate == null
                                        ? ""
                                        : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}"))),
                      ),
                      buildTextField("Age", ageController, enabled: false),
                      buildTextField("Contact Number", contactController),
                      buildTextField("Email", emailController),
                      buildTextField("Complete Address", addressController),
                      const SizedBox(height: 15),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Sex",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Row(
                        children: [
                          Radio<String>(
                            value: "Male",
                            groupValue: selectedSex,
                            onChanged: (value) {
                              setState(() => selectedSex = value!);
                            },
                          ),
                          const Text("Male"),
                          Radio<String>(
                            value: "Female",
                            groupValue: selectedSex,
                            onChanged: (value) {
                              setState(() => selectedSex = value!);
                            },
                          ),
                          const Text("Female"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Selected Sex: $selectedSex",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("EMERGENCY CONTACT",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))),
                      const SizedBox(height: 8),
                      buildTextField(
                          "Complete Name", emergencyNameController),
                      buildTextField(
                          "Contact Number", emergencyContactController),
                      buildTextField("Relation", relationController),
                      const SizedBox(height: 15),

                      // --- ID Upload Section ---
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Upload National ID",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(height: 8),

                      if (_idImage != null)
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _idImage!,
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_isVerifying)
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2)),
                                  SizedBox(width: 8),
                                  Text("Verifying ID..."),
                                ],
                              )
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _idVerified
                                        ? Icons.verified
                                        : Icons.warning_amber_rounded,
                                    color: _idVerified
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _idVerified
                                        ? "ID Verified"
                                        : "ID Not Verified – Proceed with caution",
                                    style: TextStyle(
                                      color: _idVerified
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                            // Show a preview of extracted OCR text
                            if (_extractedOcrText.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  border:
                                  Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("📄 Extracted ID Text:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text(
                                      _extractedOcrText,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("No ID selected",
                              style: TextStyle(color: Colors.grey)),
                        ),

                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: pickIDImage,
                        icon: const Icon(Icons.upload_file),
                        label: const Text("Select ID"),
                      ),

                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D47A1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                selectedDate != null &&
                                ageController.text.isNotEmpty &&
                                _idImage != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => uKonekPreviewPage(
                                        firstName:
                                        firstNameController.text,
                                        middleName:
                                        middleNameController.text,
                                        surname: surnameController.text,
                                        dob:
                                        "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                                        age: ageController.text,
                                        contact: contactController.text,
                                        sex: selectedSex,
                                        email: emailController.text,
                                        address: addressController.text,
                                        emergencyName:
                                        emergencyNameController.text,
                                        emergencyContact:
                                        emergencyContactController
                                            .text,
                                        relation: relationController.text,
                                        idImage: _idImage,
                                        idVerified: _idVerified,
                                        // Pass OCR text to preview page
                                        extractedOcrText:
                                        _extractedOcrText,
                                      )));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please complete all fields and upload your ID")));
                            }
                          },
                          child: const Text("NEXT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}