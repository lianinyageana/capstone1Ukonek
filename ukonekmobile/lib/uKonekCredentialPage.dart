import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'uKonekOtpPage.dart';
// TODO: import your sign-in page below
// import 'uKonekSignInPage.dart';

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
  final String extractedOcrText;

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
    this.extractedOcrText = "",
  });

  @override
  State<uKonekCredentialsPage> createState() => _uKonekCredentialsPageState();
}

class _uKonekCredentialsPageState extends State<uKonekCredentialsPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false; // tracks checkbox state

  // Shows a scrollable Terms & Privacy dialog
  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Terms & Privacy Policy",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1)),
              ),
              const SizedBox(height: 12),
              const SizedBox(
                height: 320,
                child: SingleChildScrollView(
                  child: Text(
                    "1. ACCEPTANCE OF TERMS\n"
                        "By creating an account with U-Konek, you agree to be bound by these Terms and Conditions and our Privacy Policy. If you do not agree, please do not proceed with registration.\n\n"
                        "2. DATA COLLECTION & USE\n"
                        "We collect personal information including your name, date of birth, contact details, address, and a government-issued ID for identity verification purposes. This information is used solely to provide U-Konek services and will not be sold to third parties.\n\n"
                        "3. IDENTITY VERIFICATION\n"
                        "You consent to our use of OCR (Optical Character Recognition) technology to read and verify the text on your uploaded ID. The extracted data is used only for verification and is stored securely.\n\n"
                        "4. ACCOUNT SECURITY\n"
                        "You are responsible for maintaining the confidentiality of your username and password. U-Konek will not be liable for any unauthorized access resulting from your failure to secure your credentials.\n\n"
                        "5. EMERGENCY CONTACT\n"
                        "The emergency contact information you provide may be used to reach your designated contact in the event of an emergency related to your account or services.\n\n"
                        "6. DATA PRIVACY\n"
                        "Your personal data is protected in accordance with the Data Privacy Act of 2012 (Republic Act No. 10173). You have the right to access, correct, and request deletion of your personal data at any time by contacting our support team.\n\n"
                        "7. PROHIBITED USE\n"
                        "You agree not to use U-Konek services for any unlawful purpose, including but not limited to identity fraud, misrepresentation, or any activity that violates applicable laws.\n\n"
                        "8. CHANGES TO TERMS\n"
                        "U-Konek reserves the right to update these Terms and Privacy Policy at any time. Continued use of the application after changes constitutes your acceptance of the revised terms.\n\n"
                        "9. CONTACT US\n"
                        "For questions or concerns about these terms, please contact us at support@ukonek.ph.",
                    style: TextStyle(fontSize: 13, height: 1.6),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Auto-check the box after reading
                    setState(() => _agreedToTerms = true);
                  },
                  child: const Text("I Understand",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                "CREATE YOUR ACCOUNT",
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
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Set up your login credentials",
                        style:
                        TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),

                      // Username
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Username is required";
                          }
                          if (value.length < 4) {
                            return "Username must be at least 4 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(() =>
                            _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          }
                          if (value != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // ── Consent / Terms Checkbox ──────────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: _agreedToTerms
                              ? Colors.blue.shade50
                              : Colors.grey.shade100,
                          border: Border.all(
                            color: _agreedToTerms
                                ? const Color(0xFF1976D2)
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _agreedToTerms,
                              activeColor: const Color(0xFF0D47A1),
                              onChanged: (value) {
                                setState(
                                        () => _agreedToTerms = value ?? false);
                              },
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87),
                                  children: [
                                    const TextSpan(
                                        text: "I have read and agree to the "),
                                    TextSpan(
                                      text: "Terms & Privacy Policy",
                                      style: const TextStyle(
                                        color: Color(0xFF1976D2),
                                        fontWeight: FontWeight.bold,
                                        decoration:
                                        TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = _showTermsDialog,
                                    ),
                                    const TextSpan(
                                        text:
                                        " of U-Konek before signing up."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Show error hint if not checked and user tries to proceed
                      if (!_agreedToTerms)
                        const Padding(
                          padding: EdgeInsets.only(left: 12, top: 4),
                          child: Text(
                            "You must agree to the terms to continue.",
                            style: TextStyle(
                                color: Colors.red, fontSize: 11),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // SIGN UP Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _agreedToTerms
                                ? const Color(0xFF0D47A1)
                                : Colors.grey,
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            if (!_agreedToTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "⚠️ Please agree to the Terms & Privacy Policy to continue."),
                                ),
                              );
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => uKonekOtpPage(
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
                                    username: usernameController.text,
                                    password: passwordController.text,
                                    idVerified: widget.idVerified,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Already have an account? Sign in
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                            children: [
                              const TextSpan(
                                  text: "Already have an account? "),
                              TextSpan(
                                text: "Sign in here",
                                style: const TextStyle(
                                  color: Color(0xFF1976D2),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // TODO: Replace with your sign-in page
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) => uKonekSignInPage(),
                                    //   ),
                                    // );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Redirecting to Sign In..."),
                                    ));
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
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
}