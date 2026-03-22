import 'package:flutter/material.dart';

class uKonekNotificationsTab extends StatefulWidget {
  const uKonekNotificationsTab({super.key});
  @override
  State<uKonekNotificationsTab> createState() =>
      _uKonekNotificationsTabState();
}

class _uKonekNotificationsTabState
    extends State<uKonekNotificationsTab> {

  static const _primary      = Color(0xFF0D47A1);
  static const _primaryLight = Color(0xFF1976D2);

  // ── Demo notifications ─────────────────────────────────────────
  final List<Map<String, Object>> _notifications = [
    {
      'title':    'Appointment Reminder',
      'body':     'You have an appointment with Dr. Santos tomorrow at 10:00 AM.',
      'time':     'Just now',
      'icon':     Icons.calendar_month_rounded,
      'color':    Color(0xFF1565C0),
      'read':     false,
      'category': 'Appointment',
    },
    {
      'title':    'Medicine Reminder',
      'body':     'Time to take your Amlodipine 5mg. Remember to take it after meal.',
      'time':     '2 hours ago',
      'icon':     Icons.medication_rounded,
      'color':    Color(0xFF7B1FA2),
      'read':     false,
      'category': 'Medicine',
    },
    {
      'title':    'Health Alert',
      'body':     'Your blood pressure reading from this morning is within normal range. Keep it up!',
      'time':     'Today, 8:35 AM',
      'icon':     Icons.favorite_rounded,
      'color':    Color(0xFFC62828),
      'read':     false,
      'category': 'Health',
    },
    {
      'title':    'Medicine Reminder',
      'body':     'Good morning! Time to take your Metformin 500mg with breakfast.',
      'time':     'Today, 8:00 AM',
      'icon':     Icons.medication_rounded,
      'color':    Color(0xFF00838F),
      'read':     true,
      'category': 'Medicine',
    },
    {
      'title':    'Appointment Confirmed',
      'body':     'Your appointment with Dr. Rey Aquino on March 28 at 2:30 PM has been confirmed.',
      'time':     'Yesterday',
      'icon':     Icons.check_circle_outline_rounded,
      'color':    Color(0xFF2E7D32),
      'read':     true,
      'category': 'Appointment',
    },
    {
      'title':    'Health Tip',
      'body':     'Stay hydrated! Drink at least 8 glasses of water daily for better health.',
      'time':     'Mar 20, 2026',
      'icon':     Icons.lightbulb_outline_rounded,
      'color':    Color(0xFFF57F17),
      'read':     true,
      'category': 'Health',
    },
    {
      'title':    'Visit Summary',
      'body':     'Your visit summary from March 10 with Dr. Santos is now available.',
      'time':     'Mar 10, 2026',
      'icon':     Icons.description_outlined,
      'color':    Color(0xFF1565C0),
      'read':     true,
      'category': 'Appointment',
    },
  ];

  int get _unreadCount =>
      _notifications.where((n) => !(n['read'] as bool)).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) n['read'] = true;
    });
  }

  void _markRead(int index) {
    setState(() => _notifications[index]['read'] = true);
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
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
            child: Row(children: [
              const Icon(Icons.notifications_rounded,
                  color: Colors.white, size: 26),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                      _unreadCount > 0
                          ? '$_unreadCount unread notification${_unreadCount > 1 ? 's' : ''}'
                          : 'All caught up!',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                ],
              )),
              if (_unreadCount > 0)
                GestureDetector(
                  onTap: _markAllRead,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Text('Mark all read',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
            ]),
          ),
        ),
      ),

      // ── Notification list ──────────────────────────────────────
      Expanded(
        child: _notifications.isEmpty
            ? _buildEmpty()
            : ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          itemCount: _notifications.length,
          itemBuilder: (_, i) =>
              _notifCard(i, _notifications[i]),
        ),
      ),
    ]);
  }

  Widget _buildEmpty() {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.notifications_off_outlined,
            size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 14),
        Text('No notifications yet',
            style: TextStyle(
                color: Colors.grey.shade500, fontSize: 15)),
        const SizedBox(height: 6),
        Text('We\'ll notify you about appointments\nand health updates here.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey.shade400, fontSize: 12)),
      ],
    ));
  }

  Widget _notifCard(int index, Map<String, Object> notif) {
    final isRead = notif['read'] as bool;
    final color  = notif['color'] as Color;

    return GestureDetector(
      onTap: () => _markRead(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isRead
                ? const Color(0xFFEEF2FF)
                : _primary.withOpacity(0.2),
            width: isRead ? 1 : 1.5,
          ),
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(isRead ? 0.03 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(notif['icon'] as IconData,
                    color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(notif['category'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: color,
                          )),
                    ),
                    const Spacer(),
                    Text(notif['time'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        )),
                    if (!isRead) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          color: _primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 6),
                  Text(notif['title'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isRead
                            ? FontWeight.w600
                            : FontWeight.bold,
                        color: const Color(0xFF1A1A2E),
                      )),
                  const SizedBox(height: 4),
                  Text(notif['body'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        height: 1.4,
                      )),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}