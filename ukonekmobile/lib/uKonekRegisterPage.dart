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
  final middleNameController = TextEditingController(); // Updated
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

  // PICK DATE
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

  // PICK ID IMAGE
  Future<void> pickIDImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _idImage = File(pickedFile.path);
      });
      await verifyID(); // auto verify after picking
    }
  }

  // VERIFY ID USING OCR + FUZZY MATCH
  Future<void> verifyID() async {
    if (_idImage == null) return;

    final inputImage = InputImage.fromFile(_idImage!);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    String normalize(String s) =>
        s.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');

    String ocrText = normalize(recognizedText.text);
    String fullNameText = normalize(
        "${firstNameController.text} ${middleNameController.text} ${surnameController.text}");
    String shortNameText =
    normalize("${firstNameController.text} ${surnameController.text}");

    double fullSimilarity = StringSimilarity.compareTwoStrings(ocrText, fullNameText);
    double shortSimilarity = StringSimilarity.compareTwoStrings(ocrText, shortNameText);

    bool matches = fullSimilarity > 0.55 || shortSimilarity > 0.55;

    setState(() {
      _idVerified = matches;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(matches
          ? "✅ ID verified"
          : "⚠️ ID may not match. Please verify."),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER
          Container(
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)]),
              borderRadius:
              BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            ),
            child: const Center(
              child: Text(
                "U-KONEK REGISTRATION",
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                      buildTextField("Middle Name", middleNameController), // updated
                      buildTextField("Surname", surnameController),

                      // DOB
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
                      buildTextField("Email", emailController),
                      buildTextField("Complete Address", addressController),

                      const SizedBox(height: 15),

                      // SEX
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Sex", style: TextStyle(fontWeight: FontWeight.bold))),
                      Row(
                        children: [
                          Radio<String>(
                            value: "Male",
                            groupValue: selectedSex,
                            onChanged: (value) {
                              setState(() {
                                selectedSex = value!;
                              });
                            },
                          ),
                          const Text("Male"),
                          Radio<String>(
                            value: "Female",
                            groupValue: selectedSex,
                            onChanged: (value) {
                              setState(() {
                                selectedSex = value!;
                              });
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
                                style: const TextStyle(fontWeight: FontWeight.bold))),
                      ),

                      const SizedBox(height: 15),

                      // EMERGENCY CONTACT
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("EMERGENCY CONTACT",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      const SizedBox(height: 8),
                      buildTextField("Complete Name", emergencyNameController),
                      buildTextField("Contact Number", emergencyContactController),
                      buildTextField("Relation", relationController),

                      const SizedBox(height: 15),

                      // ID UPLOAD
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Upload National ID",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(height: 8),
                      _idImage != null
                          ? Column(
                        children: [
                          Image.file(_idImage!,
                              width: 200, height: 120, fit: BoxFit.cover),
                          const SizedBox(height: 5),
                          Text(
                            _idVerified ? "✅ ID Verified" : "⚠️ ID Not Verified",
                            style: TextStyle(
                                color: _idVerified ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                          : const Text("No ID selected"),
                      ElevatedButton(
                          onPressed: pickIDImage, child: const Text("Select ID")),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              selectedDate != null &&
                              ageController.text.isNotEmpty &&
                              _idImage != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => uKonekPreviewPage(
                                      firstName: firstNameController.text,
                                      middleName: middleNameController.text, // updated
                                      surname: surnameController.text,
                                      dob:
                                      "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                                      age: ageController.text,
                                      contact: contactController.text,
                                      sex: selectedSex,
                                      email: emailController.text,
                                      address: addressController.text,
                                      emergencyName: emergencyNameController.text,
                                      emergencyContact: emergencyContactController.text,
                                      relation: relationController.text,
                                      idImage: _idImage,
                                      idVerified: _idVerified,
                                    )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please complete all fields and upload your ID")));
                          }
                        },
                        child: const Text("NEXT"),
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