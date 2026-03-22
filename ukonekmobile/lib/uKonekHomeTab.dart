import 'package:flutter/material.dart';

class uKonekHomeTab extends StatelessWidget {
  final String username;
  final String firstName;
  final String surname;
  final bool   idVerified;
  final void Function(int) onTabChange;

  const uKonekHomeTab({
    super.key,
    required this.username,
    required this.firstName,
    required this.surname,
    required this.idVerified,
    required this.onTabChange,
  });

  static const _primary      = Color(0xFF0D47A1);
  static const _primaryLight = Color(0xFF1976D2);

  String get _displayName =>
      firstName.isNotEmpty ? firstName : username;

  String get _initials {
    if (firstName.isNotEmpty && surname.isNotEmpty)
      return '${firstName[0]}${surname[0]}'.toUpperCase();
    return username.isNotEmpty ? username[0].toUpperCase() : 'U';
  }

  // ── Demo data ─────────────────────────────────────────────────
  static const List<Map<String, Object>> _vitals = [
    {'label': 'Heart Rate',     'value': '78',     'unit': 'bpm',  'icon': Icons.favorite_rounded,        'color': Color(0xFFC62828)},
    {'label': 'Blood Pressure', 'value': '120/80', 'unit': 'mmHg', 'icon': Icons.monitor_heart_outlined,  'color': Color(0xFF1565C0)},
    {'label': 'Weight',         'value': '65',     'unit': 'kg',   'icon': Icons.monitor_weight_outlined, 'color': Color(0xFF558B2F)},
    {'label': 'Temperature',    'value': '36.6',   'unit': '°C',   'icon': Icons.thermostat_rounded,      'color': Color(0xFFE65100)},
  ];

  static const List<Map<String, Object>> _medicines = [
    {'name': 'Metformin 500mg',   'time': '8:00 AM',  'meal': 'With meal',  'color': Color(0xFF00838F), 'taken': true},
    {'name': 'Amlodipine 5mg',    'time': '8:00 PM',  'meal': 'After meal', 'color': Color(0xFF7B1FA2), 'taken': false},
    {'name': 'Vitamin D3 1000IU', 'time': '12:00 PM', 'meal': 'With meal',  'color': Color(0xFFF57F17), 'taken': false},
  ];

  static const List<Map<String, Object>> _quickActions = [
    {'icon': Icons.calendar_month_outlined,     'label': 'Book\nAppointment', 'color': Color(0xFF1565C0), 'tab': 1},
    {'icon': Icons.medication_outlined,         'label': 'My\nMedicines',     'color': Color(0xFF00838F), 'tab': -1},
    {'icon': Icons.monitor_heart_outlined,      'label': 'My\nVitals',        'color': Color(0xFFC62828), 'tab': -1},
    {'icon': Icons.chat_bubble_outline_rounded, 'label': 'Consult\nDoctor',   'color': Color(0xFF558B2F), 'tab': -1},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildHeader(context),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!idVerified) _buildIDWarning(),
              _label('Quick Actions'),
              const SizedBox(height: 12),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildAppointmentBanner(context),
              const SizedBox(height: 24),
              _label('Today\'s Vitals'),
              const SizedBox(height: 12),
              _buildVitalsGrid(),
              const SizedBox(height: 24),
              _buildMedicines(),
              const SizedBox(height: 24),
              _buildConsultBanner(context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    ]);
  }

  // ── Header ─────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
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
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          child: Column(children: [
            Row(children: [
              // Avatar
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    blurRadius: 10,
                  )],
                ),
                child: Center(child: Text(_initials,
                    style: const TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, $_displayName 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 2),
                  const Text('How are you feeling today?',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              )),
              // Notification bell with red dot
              GestureDetector(
                onTap: () => onTabChange(3),
                child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(alignment: Alignment.center, children: [
                    const Icon(Icons.notifications_none_rounded,
                        color: Colors.white, size: 24),
                    Positioned(
                      top: 8, right: 9,
                      child: Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5252),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
            const SizedBox(height: 18),
            // Health status row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: Row(children: [
                const Icon(Icons.shield_outlined, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Health Status',
                        style: TextStyle(color: Colors.white70, fontSize: 11)),
                    SizedBox(height: 2),
                    Text('All vitals normal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.green.shade300.withOpacity(0.5)),
                  ),
                  child: const Text('Good',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  // ── ID warning ─────────────────────────────────────────────────
  Widget _buildIDWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        Icon(Icons.warning_amber_rounded,
            color: Colors.orange.shade700, size: 22),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Not Verified',
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                )),
            const SizedBox(height: 2),
            Text('Please visit the health center to verify your National ID.',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontSize: 11,
                )),
          ],
        )),
      ]),
    );
  }

  // ── Quick actions ──────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: _quickActions.asMap().entries.map((e) {
        final i      = e.key;
        final action = e.value;
        final color  = action['color'] as Color;
        final tab    = action['tab'] as int;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (tab > 0) {
                onTabChange(tab);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      '${(action['label'] as String).replaceAll('\n', ' ')} coming soon.'),
                  duration: const Duration(seconds: 2),
                ));
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                  right: i < _quickActions.length - 1 ? 10 : 0),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )],
              ),
              child: Column(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(action['icon'] as IconData,
                      color: color, size: 22),
                ),
                const SizedBox(height: 8),
                Text(action['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                    )),
              ]),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Appointment banner ─────────────────────────────────────────
  Widget _buildAppointmentBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => onTabChange(1),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )],
        ),
        child: Row(children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.calendar_month_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Next Appointment',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
              SizedBox(height: 4),
              Text('Dr. Santos — General',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
              SizedBox(height: 2),
              Text('Tomorrow, 10:00 AM',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('View',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                )),
          ),
        ]),
      ),
    );
  }

  // ── Vitals 2×2 grid ───────────────────────────────────────────
  Widget _buildVitalsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   2,
        crossAxisSpacing: 12,
        mainAxisSpacing:  12,
        childAspectRatio: 2.0,
      ),
      itemCount: _vitals.length,
      itemBuilder: (_, i) {
        final v     = _vitals[i];
        final color = v['color'] as Color;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )],
          ),
          child: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(v['icon'] as IconData, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(v['label'] as String,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                const SizedBox(height: 2),
                RichText(text: TextSpan(children: [
                  TextSpan(
                      text: v['value'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      )),
                  TextSpan(
                      text: ' ${v['unit']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                      )),
                ])),
              ],
            )),
          ]),
        );
      },
    );
  }

  // ── Medicines ──────────────────────────────────────────────────
  Widget _buildMedicines() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _label('Today\'s Medicines'),
        TextButton(
          onPressed: () {},
          child: const Text('See all',
              style: TextStyle(
                color: _primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              )),
        ),
      ]),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )],
        ),
        child: Column(
          children: _medicines.asMap().entries.map((e) {
            final i     = e.key;
            final med   = e.value;
            final taken = med['taken'] as bool;
            final color = med['color'] as Color;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.medication_rounded,
                        color: color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(med['name'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E),
                          )),
                      const SizedBox(height: 3),
                      Text('${med['time']} • ${med['meal']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          )),
                    ],
                  )),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: taken
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: taken
                            ? Colors.green.shade200
                            : Colors.orange.shade200,
                      ),
                    ),
                    child: Text(taken ? '✓ Taken' : 'Pending',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: taken
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        )),
                  ),
                ]),
              ),
              if (i < _medicines.length - 1)
                const Divider(height: 1, indent: 70,
                    color: Color(0xFFEEF2FF)),
            ]);
          }).toList(),
        ),
      ),
    ]);
  }

  // ── Consult banner ─────────────────────────────────────────────
  Widget _buildConsultBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: const Color(0xFF2E7D32).withOpacity(0.25),
          blurRadius: 14,
          offset: const Offset(0, 6),
        )],
      ),
      child: Row(children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.chat_bubble_outline_rounded,
              color: Colors.white, size: 26),
        ),
        const SizedBox(width: 14),
        const Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need Medical Advice?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
            SizedBox(height: 4),
            Text('Send a message to your assigned doctor.',
                style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        )),
        GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Consult feature coming soon.'))),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                )),
          ),
        ),
      ]),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A2E),
      ));
}