import 'package:flutter/material.dart';
import 'uKonekLoginPage.dart';

class uKonekProfileTab extends StatelessWidget {
  final String username;
  final String firstName;
  final String surname;
  final String dob;
  final String sex;
  final String contact;
  final String address;
  final String emergencyName;
  final String emergencyContact;
  final String relation;
  final bool   idVerified;

  const uKonekProfileTab({
    super.key,
    required this.username,
    required this.firstName,
    required this.surname,
    required this.dob,
    required this.sex,
    required this.contact,
    required this.address,
    required this.emergencyName,
    required this.emergencyContact,
    required this.relation,
    required this.idVerified,
  });

  static const _primary      = Color(0xFF0D47A1);
  static const _primaryLight = Color(0xFF1976D2);

  String get _fullName {
    if (firstName.isNotEmpty && surname.isNotEmpty)
      return '$firstName $surname';
    return username;
  }

  String get _initials {
    if (firstName.isNotEmpty && surname.isNotEmpty)
      return '${firstName[0]}${surname[0]}'.toUpperCase();
    return username.isNotEmpty ? username[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ── Header ────────────────────────────────────────────────
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_primary, _primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft:  Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 32),
            child: Column(children: [
              const Text('My Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20),
              // Avatar circle
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )],
                ),
                child: Center(child: Text(_initials,
                    style: const TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ))),
              ),
              const SizedBox(height: 12),
              Text(_fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 4),
              Text('@$username',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 10),
              // ID Verified badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: idVerified
                      ? Colors.green.withOpacity(0.25)
                      : Colors.orange.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: idVerified
                        ? Colors.green.shade300.withOpacity(0.5)
                        : Colors.orange.shade300.withOpacity(0.5),
                  ),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    idVerified
                        ? Icons.verified_rounded
                        : Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                      idVerified ? 'ID Verified' : 'ID Not Verified',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )),
                ]),
              ),
            ]),
          ),
        ),
      ),

      // ── Info sections ──────────────────────────────────────────
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Personal Info
            _infoCard('Personal Information', Icons.person_outline_rounded, [
              _infoRow('Full Name',    _fullName.isNotEmpty ? _fullName : '—'),
              _infoRow('Username',     username.isNotEmpty  ? username  : '—'),
              _infoRow('Date of Birth',dob.isNotEmpty       ? dob       : '—'),
              _infoRow('Sex',          sex.isNotEmpty       ? sex       : '—'),
            ]),
            const SizedBox(height: 16),

            // Contact Info
            _infoCard('Contact Information', Icons.contact_phone_outlined, [
              _infoRow('Phone Number', contact.isNotEmpty ? contact : '—'),
              _infoRow('Address',      address.isNotEmpty ? address : '—'),
            ]),
            const SizedBox(height: 16),

            // Emergency Contact
            _infoCard('Emergency Contact', Icons.emergency_outlined, [
              _infoRow('Name',         emergencyName.isNotEmpty
                  ? emergencyName : '—'),
              _infoRow('Phone Number', emergencyContact.isNotEmpty
                  ? emergencyContact : '—'),
              _infoRow('Relation',     relation.isNotEmpty
                  ? relation : '—'),
            ]),
            const SizedBox(height: 16),

            // Health Center
            _infoCard('Health Center', Icons.local_hospital_outlined, [
              _infoRow('Assigned Barangay', 'Ugong'),
              _infoRow('Health Center',
                  'Barangay Ugong 3S Health Center'),
              _infoRow('City', 'Valenzuela City'),
            ]),
            const SizedBox(height: 24),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout_rounded,
                    color: Colors.red, size: 20),
                label: const Text('Logout',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    ]);
  }

  // ── Info card ──────────────────────────────────────────────────
  Widget _infoCard(
      String title, IconData icon, List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 14,
          offset: const Offset(0, 4),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  )),
            ]),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEEF2FF)),
          // Rows
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: rows),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                )),
          ),
          Expanded(child: Text(value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ))),
        ],
      ),
    );
  }

  // ── Logout confirmation ────────────────────────────────────────
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const uKonekLoginPage()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}