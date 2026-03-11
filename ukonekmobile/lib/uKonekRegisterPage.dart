import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'uKonekPreviewPage.dart';

class uKonekRegisterPage extends StatefulWidget {
  const uKonekRegisterPage({super.key});

  @override
  State<uKonekRegisterPage> createState() => _uKonekRegisterPageState();
}

class _uKonekRegisterPageState extends State<uKonekRegisterPage> {

  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final middleInitialController = TextEditingController();
  final surnameController = TextEditingController();
  final ageController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final emergencyNameController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final relationController = TextEditingController();

  DateTime? selectedDate;
  String selectedCountryCode = "+63";
  String selectedSex = "Male";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // 🔵 CURVED HEADER (Figma Style)
          Container(
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: const Center(
              child: Text(
                "U-KONEK REGISTRATION",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                      buildTextField("Middle Initial", middleInitialController),
                      buildTextField("Surname", surnameController),

                      // DATE OF BIRTH
                      GestureDetector(
                        onTap: pickDate,
                        child: AbsorbPointer(
                          child: buildTextField(
                            "Date of Birth",
                            TextEditingController(
                              text: selectedDate == null
                                  ? ""
                                  : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                            ),
                          ),
                        ),
                      ),

                      buildTextField("Age", ageController, enabled: false),

                      const SizedBox(height: 10),

                      // CONTACT NUMBER
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: selectedCountryCode,
                            items: const [
                              DropdownMenuItem(value: "+63", child: Text("+63 PH")),
                              DropdownMenuItem(value: "+1", child: Text("+1 US")),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedCountryCode = value!;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: contactController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: selectedCountryCode == "+63"
                                  ? [PhoneInputFormatter(defaultCountryCode: 'PH')]
                                  : null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Contact number required";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Contact Number",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // SEX
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Sex", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),

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

                      buildTextField("Email", emailController),
                      buildTextField("Complete Address", addressController),

                      const SizedBox(height: 20),

                      const SizedBox(height: 25),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "EMERGENCY CONTACT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      buildTextField("Complete Name", emergencyNameController),
                      buildTextField("Contact Number", emergencyContactController),
                      buildTextField("Relation", relationController),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              selectedDate != null &&
                              ageController.text.isNotEmpty) {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => uKonekPreviewPage(
                                  firstName: firstNameController.text,
                                  middleInitial: middleInitialController.text,
                                  surname: surnameController.text,
                                  dob: "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                                  age: ageController.text,
                                  contact: "$selectedCountryCode ${contactController.text}",
                                  sex: selectedSex,
                                  email: emailController.text,
                                  address: addressController.text,
                                  emergencyName: emergencyNameController.text,
                                  emergencyContact: emergencyContactController.text,
                                  relation: relationController.text,
                                ),
                              ),
                            );

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please complete required fields."),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(180, 50),
                        ),
                        child: const Text("NEXT"),
                      )
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