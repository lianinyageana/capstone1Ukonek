import 'package:flutter/material.dart';
import 'uKonekHomeTab.dart';
import 'uKonekAppointmentsTab.dart';
import 'uKonekProfileTab.dart';
import 'uKonekNotificationsTab.dart';

class uKonekDashboardPage extends StatefulWidget {
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

  const uKonekDashboardPage({
    super.key,
    this.username         = 'User',
    this.firstName        = '',
    this.surname          = '',
    this.dob              = '',
    this.sex              = '',
    this.contact          = '',
    this.address          = '',
    this.emergencyName    = '',
    this.emergencyContact = '',
    this.relation         = '',
    this.idVerified       = false,
  });

  @override
  State<uKonekDashboardPage> createState() => _uKonekDashboardPageState();
}

class _uKonekDashboardPageState extends State<uKonekDashboardPage> {
  int _selectedIndex = 0;

  static const _primary      = Color(0xFF0D47A1);
  static const _primaryLight = Color(0xFF1976D2);

  static const _navItems = [
    {'icon': Icons.home_rounded,           'label': 'Home'},
    {'icon': Icons.calendar_month_rounded, 'label': 'Schedule'},
    {'icon': Icons.person_rounded,         'label': 'Profile'},
    {'icon': Icons.notifications_rounded,  'label': 'Alerts'},
  ];

  Widget _buildTab(int index) {
    switch (index) {
      case 0:
        return uKonekHomeTab(
          username:    widget.username,
          firstName:   widget.firstName,
          surname:     widget.surname,
          idVerified:  widget.idVerified,
          onTabChange: (i) => setState(() => _selectedIndex = i),
        );
      case 1:
        return const uKonekAppointmentsTab();
      case 2:
        return uKonekProfileTab(
          username:         widget.username,
          firstName:        widget.firstName,
          surname:          widget.surname,
          dob:              widget.dob,
          sex:              widget.sex,
          contact:          widget.contact,
          address:          widget.address,
          emergencyName:    widget.emergencyName,
          emergencyContact: widget.emergencyContact,
          relation:         widget.relation,
          idVerified:       widget.idVerified,
        );
      case 3:
        return const uKonekNotificationsTab();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(4, _buildTab),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 20,
          offset: const Offset(0, -4),
        )],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: List.generate(_navItems.length, (i) {
              final item     = _navItems[i];
              final selected = _selectedIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? _primary.withOpacity(0.09)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      AnimatedScale(
                        scale: selected ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          item['icon'] as IconData,
                          color: selected ? _primary : Colors.grey.shade400,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(item['label'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            color: selected ? _primary : Colors.grey.shade400,
                          )),
                    ]),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}