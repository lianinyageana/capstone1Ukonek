import 'package:flutter/material.dart';

class uKonekAppointmentsTab extends StatefulWidget {
  const uKonekAppointmentsTab({super.key});
  @override
  State<uKonekAppointmentsTab> createState() =>
      _uKonekAppointmentsTabState();
}

class _uKonekAppointmentsTabState
    extends State<uKonekAppointmentsTab>
    with SingleTickerProviderStateMixin {

  static const _primary      = Color(0xFF0D47A1);
  static const _primaryLight = Color(0xFF1976D2);

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Demo data ─────────────────────────────────────────────────
  static const List<Map<String, Object>> _upcoming = [
    {
      'doctor':   'Dr. Maria Santos',
      'specialty':'General Practice',
      'date':     'Tomorrow',
      'time':     '10:00 AM',
      'location': 'Room 2 — Ugong 3S Health Center',
      'status':   'Confirmed',
      'color':    Color(0xFF1565C0),
    },
    {
      'doctor':   'Dr. Rey Aquino',
      'specialty':'Pediatrics',
      'date':     'Mar 28, 2026',
      'time':     '2:30 PM',
      'location': 'Room 4 — Ugong 3S Health Center',
      'status':   'Pending',
      'color':    Color(0xFF558B2F),
    },
  ];

  static const List<Map<String, Object>> _past = [
    {
      'doctor':   'Dr. Maria Santos',
      'specialty':'General Practice',
      'date':     'Mar 10, 2026',
      'time':     '9:00 AM',
      'location': 'Room 2 — Ugong 3S Health Center',
      'status':   'Completed',
      'color':    Color(0xFF00838F),
    },
    {
      'doctor':   'Dr. Jose Reyes',
      'specialty':'Internal Medicine',
      'date':     'Feb 20, 2026',
      'time':     '11:00 AM',
      'location': 'Room 1 — Ugong 3S Health Center',
      'status':   'Completed',
      'color':    Color(0xFF00838F),
    },
    {
      'doctor':   'Dr. Maria Santos',
      'specialty':'General Practice',
      'date':     'Jan 15, 2026',
      'time':     '8:00 AM',
      'location': 'Room 2 — Ugong 3S Health Center',
      'status':   'Cancelled',
      'color':    Color(0xFFC62828),
    },
  ];

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
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: 26),
                const SizedBox(width: 10),
                const Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Appointments',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('Ugong 3S Health Center',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                )),
                // Book button
                GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Booking feature coming soon.'))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Row(children: [
                      Icon(Icons.add_rounded,
                          color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('Book',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          )),
                    ]),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              // Tab bar
              TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: _primary,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13),
                unselectedLabelStyle:
                const TextStyle(fontSize: 13),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Past'),
                ],
              ),
              const SizedBox(height: 4),
            ]),
          ),
        ),
      ),

      // ── Tab views ─────────────────────────────────────────────
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildList(_upcoming, upcoming: true),
            _buildList(_past,     upcoming: false),
          ],
        ),
      ),
    ]);
  }

  Widget _buildList(
      List<Map<String, Object>> items, {required bool upcoming}) {
    if (items.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined,
              size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(upcoming
              ? 'No upcoming appointments'
              : 'No past appointments',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ],
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      itemCount: items.length,
      itemBuilder: (_, i) => _appointmentCard(items[i], upcoming: upcoming),
    );
  }

  Widget _appointmentCard(
      Map<String, Object> appt, {required bool upcoming}) {
    final color   = appt['color'] as Color;
    final status  = appt['status'] as String;

    Color statusColor;
    Color statusBg;
    switch (status) {
      case 'Confirmed':
        statusColor = Colors.green.shade700;
        statusBg    = Colors.green.shade50;
        break;
      case 'Pending':
        statusColor = Colors.orange.shade700;
        statusBg    = Colors.orange.shade50;
        break;
      case 'Cancelled':
        statusColor = Colors.red.shade700;
        statusBg    = Colors.red.shade50;
        break;
      default:
        statusColor = Colors.teal.shade700;
        statusBg    = Colors.teal.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 14,
          offset: const Offset(0, 4),
        )],
      ),
      child: Column(children: [
        // Color top bar
        Container(
          height: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft:  Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(Icons.local_hospital_outlined,
                      color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appt['doctor'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        )),
                    const SizedBox(height: 2),
                    Text(appt['specialty'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        )),
                  ],
                )),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      )),
                ),
              ]),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFEEF2FF)),
              const SizedBox(height: 12),
              // Date + time + location
              _infoRow(Icons.calendar_today_outlined,
                  '${appt['date']} at ${appt['time']}', color),
              const SizedBox(height: 8),
              _infoRow(Icons.location_on_outlined,
                  appt['location'] as String, color),
              if (upcoming) ...[
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: OutlinedButton(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        content: Text('Cancel feature coming soon.'))),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(fontSize: 13)),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: ElevatedButton(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        content: Text('Details feature coming soon.'))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text('View Details',
                        style: TextStyle(fontSize: 13)),
                  )),
                ]),
              ],
            ],
          ),
        ),
      ]),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) {
    return Row(children: [
      Icon(icon, size: 16, color: color.withOpacity(0.7)),
      const SizedBox(width: 8),
      Expanded(child: Text(text,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
    ]);
  }
}